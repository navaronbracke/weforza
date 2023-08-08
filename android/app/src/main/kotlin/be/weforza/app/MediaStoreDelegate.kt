package be.weforza.app

import android.app.DownloadManager
import android.content.ContentResolver
import android.content.ContentValues
import android.content.Context
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import java.io.BufferedReader
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileInputStream
import java.io.FileReader
import java.io.InputStream

/**
 * This class provides a delegate to interact with the MediaStore.
 */
class MediaStoreDelegate {
    companion object {
        const val FILE_DOES_NOT_EXIST_ERROR_CODE = "MEDIA_STORE_FILE_DOES_NOT_EXIST"
        const val FILE_DOES_NOT_EXIST_ERROR_MESSAGE = "The given file does not exist."
        const val INSERT_FILE_FAILED_ERROR_CODE = "MEDIA_STORE_INSERT_FILE_FAILED"
        const val INSERT_FILE_FAILED_ERROR_MESSAGE = "Could not insert a record for the file."
        const val INVALID_ARGUMENT_ERROR_CODE = "MEDIA_STORE_INVALID_ARGUMENT"
        const val INVALID_ARGUMENT_ERROR_MESSAGE = "Missing required argument."
        const val READ_FILE_FAILED_ERROR_CODE = "MEDIA_STORE_READ_FILE_FAILED"
        const val READ_FILE_FAILED_ERROR_MESSAGE = "Could not read the given file."
        const val WRITE_FILE_FAILED_ERROR_CODE = "MEDIA_STORE_WRITE_FILE_FAILED"
        const val WRITE_FILE_FAILED_ERROR_MESSAGE = "Could not write to the output file."
    }

    /**
     * Get the bytes corresponding to the content of a given content Uri.
     *
     * The result resolves with the ByteArray containing the bytes of the content.
     */
    fun getBytesFromContentUri(
        call: MethodCall,
        result: Result,
        contentResolver: ContentResolver,
    ) {
        val contentUri = Uri.parse(call.argument<String>("contentUri") ?: "")

        if(!contentUri.scheme.equals("content")) {
            result.error(INVALID_ARGUMENT_ERROR_CODE, INVALID_ARGUMENT_ERROR_MESSAGE, null)
            return
        }

        var inputStream: InputStream? = null

        try {
            inputStream = contentResolver.openInputStream(contentUri)

            if(inputStream == null) {
                result.error(READ_FILE_FAILED_ERROR_CODE, READ_FILE_FAILED_ERROR_MESSAGE, null)
                return
            }

            val buffer = ByteArrayOutputStream()
            val data = ByteArray(4096)

            var bytesRead: Int

            while (inputStream.read(data, 0, data.size).also { bytesRead = it } != -1) {
                buffer.write(data, 0, bytesRead)
            }

            buffer.flush()

            return result.success(buffer.toByteArray())
        } catch (exception: Exception) {
            result.error(READ_FILE_FAILED_ERROR_CODE, READ_FILE_FAILED_ERROR_MESSAGE, null)
        } finally {
            inputStream?.close()
        }
    }

    /**
     * Returns whether Scoped Storage is in use.
     */
    fun hasScopedStorage() : Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q
    }

    /**
     * Inform the DownloadManager about a new document file.
     *
     * This method should only be used on Android 9 and lower, where ScopedStorage is not in use.
     *
     * The method call arguments should contain a file path, file name, file size in bytes
     * and the file MIME-type.
     *
     * The result returns with an error if:
     *  - any required argument is omitted.
     */
    fun informDownloadManagerAboutDocument(call: MethodCall, result: Result, context: Context) {
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            result.error(
                INVALID_ARGUMENT_ERROR_CODE,
                INVALID_ARGUMENT_ERROR_MESSAGE,
                "informDownloadManagerAboutDocument() was called when ScopedStorage is in use.")
            return
        }

        val filePath = call.argument<String>("filePath")
        val fileName = call.argument<String>("fileName")
        val fileMimeType = call.argument<String>("fileType")
        val fileSize = call.argument<Number>("fileSize")?.toLong()

        if(filePath == null || fileName == null || fileMimeType == null || fileSize == null) {
            result.error(INVALID_ARGUMENT_ERROR_CODE, INVALID_ARGUMENT_ERROR_MESSAGE, null)
            return
        }

        val documentFile = File(filePath)

        if(!documentFile.exists()) {
            result.error(FILE_DOES_NOT_EXIST_ERROR_CODE, FILE_DOES_NOT_EXIST_ERROR_MESSAGE, null)
            return
        }

        val downloadManager: DownloadManager = context.getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager

        @Suppress("DEPRECATION")
        downloadManager.addCompletedDownload(
            fileName,
            fileName,
            true,
            fileMimeType,
            filePath,
            fileSize,
            true)

        result.success(null)
    }

    /**
     * Insert a new document in the MediaStore, using ScopedStorage.
     * The method call arguments should contain a file path, file name, file MIME-type and the file size.
     *
     * The result returns with an error if:
     *  - any required argument is omitted.
     *  - the MediaStore failed to insert an entry for the document.
     *  - the MediaStore failed to write the contents to the output file.
     */
    @RequiresApi(api = Build.VERSION_CODES.Q)
    fun insertNewDocumentInMediaStore(
        call: MethodCall,
        result: Result,
        contentResolver: ContentResolver,
    ) {
        val filePath = call.argument<String>("filePath")
        val fileName = call.argument<String>("fileName")
        val fileMimeType = call.argument<String>("fileType")
        val fileSize = call.argument<Number>("fileSize")?.toInt()

        if(filePath == null || fileName == null || fileMimeType == null || fileSize == null) {
            result.error(INVALID_ARGUMENT_ERROR_CODE, INVALID_ARGUMENT_ERROR_MESSAGE, null)
            return
        }

        val subDirectory = File.separator + "WeForza"

        val contentValues = ContentValues()
        contentValues.put(MediaStore.Files.FileColumns.DISPLAY_NAME, fileName)
        contentValues.put(MediaStore.Files.FileColumns.TITLE, fileName)
        contentValues.put(MediaStore.Files.FileColumns.MIME_TYPE, fileMimeType)
        contentValues.put(MediaStore.Files.FileColumns.SIZE, fileSize)
        contentValues.put(MediaStore.Files.FileColumns.DATE_ADDED, System.currentTimeMillis())
        contentValues.put(MediaStore.Files.FileColumns.RELATIVE_PATH, Environment.DIRECTORY_DOCUMENTS + subDirectory)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            contentValues.put(MediaStore.Files.FileColumns.MEDIA_TYPE, MediaStore.Files.FileColumns.MEDIA_TYPE_DOCUMENT)
        }

        var documentUri: Uri? = null

        try {
            documentUri = contentResolver.insert(MediaStore.Files.getContentUri(MediaStore.VOLUME_EXTERNAL), contentValues)
        } catch (exception: Exception) {
            // Fallthrough to handle the null document URI.
        }

        if(documentUri == null) {
            result.error(INSERT_FILE_FAILED_ERROR_CODE, INSERT_FILE_FAILED_ERROR_MESSAGE, null)
            return
        }

        contentResolver.openOutputStream(documentUri)?.use { outputStream ->
            BufferedReader(FileReader(File(filePath))).use { fileReader ->
                try {
                    var line: String?

                    while(fileReader.readLine().also { line = it } != null) {
                        outputStream.write(line?.toByteArray())
                        outputStream.write(System.lineSeparator().toByteArray())
                    }

                    result.success(null)
                } catch (exception: Exception) {
                    // Delete the orphaned MediaStore record.
                    contentResolver.delete(documentUri, null, null)

                    result.error(
                        WRITE_FILE_FAILED_ERROR_CODE,
                        WRITE_FILE_FAILED_ERROR_MESSAGE,
                        exception.message
                    )
                }
            }
        }
    }

    /**
     * Insert a new image in the MediaStore.
     *
     * The method call arguments should contain the file path, the file MIME-type,
     * the file name and the file size.
     *
     * The result returns with an error if:
     *  - any required argument is omitted.
     *  - the MediaStore failed to insert an entry for the image.
     *  - the MediaStore failed to write the contents to the output file.
     *
     *  The result completes with the Uri of the image that was inserted into the MediaStore.
     */
    fun insertNewImageInMediaStore(
        call: MethodCall,
        result: Result,
        contentResolver: ContentResolver,
    ) {
        val filePath = call.argument<String>("filePath")
        val fileName = call.argument<String>("fileName")
        val fileMimeType = call.argument<String>("fileType")
        val fileSize = call.argument<Number>("fileSize")?.toInt()

        if(filePath == null || fileName == null || fileSize == null) {
            result.error(INVALID_ARGUMENT_ERROR_CODE, INVALID_ARGUMENT_ERROR_MESSAGE, null)
            return
        }

        if(fileMimeType == null || !fileMimeType.startsWith("image/")) {
            result.error(INVALID_ARGUMENT_ERROR_CODE, INVALID_ARGUMENT_ERROR_MESSAGE, null)
            return
        }

        val contentValues = ContentValues()
        contentValues.put(MediaStore.Images.ImageColumns.DISPLAY_NAME, fileName)
        contentValues.put(MediaStore.Images.ImageColumns.TITLE, fileName)
        contentValues.put(MediaStore.Images.ImageColumns.MIME_TYPE, fileMimeType)
        contentValues.put(MediaStore.Images.ImageColumns.SIZE, fileSize)
        contentValues.put(MediaStore.Images.ImageColumns.DATE_ADDED, System.currentTimeMillis())

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            // The Images table does not support subdirectories.
            contentValues.put(MediaStore.Images.ImageColumns.RELATIVE_PATH, Environment.DIRECTORY_PICTURES)
        }

        var imageUri: Uri? = null

        try {
            imageUri = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)
        } catch (exception: Exception) {
            // Fallthrough to handle the null image URI.
        }

        if(imageUri == null) {
            result.error(INSERT_FILE_FAILED_ERROR_CODE, INSERT_FILE_FAILED_ERROR_MESSAGE, null)
            return
        }

        contentResolver.openOutputStream(imageUri)?.use { outputStream ->
            FileInputStream(File(filePath)).use { fileReader ->
                try {
                    val buffer = ByteArray(4096)
                    var bytesRead: Int

                    while(fileReader.read(buffer).also { bytesRead = it } != -1) {
                        outputStream.write(buffer, 0, bytesRead)
                    }

                    result.success(imageUri.toString())
                } catch (exception: Exception) {
                    // Delete the orphaned MediaStore record.
                    contentResolver.delete(imageUri, null, null)

                    result.error(
                        WRITE_FILE_FAILED_ERROR_CODE,
                        WRITE_FILE_FAILED_ERROR_MESSAGE,
                        exception.message
                    )
                }
            }
        }
    }
}