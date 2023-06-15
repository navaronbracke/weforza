package be.weforza.app

import android.content.ContentResolver
import android.content.ContentValues
import android.content.Context
import android.media.MediaScannerConnection
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import java.io.BufferedReader
import java.io.File
import java.io.FileReader

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
        const val WRITE_FILE_FAILED_ERROR_CODE = "MEDIA_STORE_WRITE_FILE_FAILED"
        const val WRITE_FILE_FAILED_ERROR_MESSAGE = "Could not write to the output file."
    }

    /**
     * Returns whether Scoped Storage is in use.
     */
    fun hasScopedStorage() : Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q
    }

    /**
     * Insert a new document in the MediaStore, using a MediaScannerConnection.
     * The method call arguments should contain a file path and the file MIME-type.
     *
     * The result returns with an error if:
     *  - any required argument is omitted.
     *  - the MediaStore failed to insert an entry for the document.
     */
    fun insertNewDocumentInMediaStore(call: MethodCall, result: Result, context: Context) {
        val filePath = call.argument<String>("filePath")
        val fileMimeType = call.argument<String>("fileType")

        if(filePath == null || fileMimeType == null) {
            result.error(INVALID_ARGUMENT_ERROR_CODE, INVALID_ARGUMENT_ERROR_MESSAGE, null)
            return
        }

        val documentFile = File(filePath)

        if(!documentFile.exists()) {
            result.error(FILE_DOES_NOT_EXIST_ERROR_CODE, FILE_DOES_NOT_EXIST_ERROR_MESSAGE, null)
            return
        }

        MediaScannerConnection.scanFile(
            context,
            arrayOf(documentFile.absolutePath),
            arrayOf(fileMimeType)
        ) { _, uri ->
            if(uri == null) {
                result.error(INSERT_FILE_FAILED_ERROR_CODE, INSERT_FILE_FAILED_ERROR_MESSAGE, null)
            } else {
                result.success(null)
            }
        }
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

        val contentValues = ContentValues()
        contentValues.put(MediaStore.Files.FileColumns.DISPLAY_NAME, fileName)
        contentValues.put(MediaStore.Files.FileColumns.TITLE, fileName)
        contentValues.put(MediaStore.Files.FileColumns.MIME_TYPE, fileMimeType)
        contentValues.put(MediaStore.Files.FileColumns.SIZE, fileSize)
        contentValues.put(MediaStore.Files.FileColumns.DATE_ADDED, System.currentTimeMillis())

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            contentValues.put(MediaStore.Files.FileColumns.MEDIA_TYPE, MediaStore.Files.FileColumns.MEDIA_TYPE_DOCUMENT)
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            contentValues.put(MediaStore.Files.FileColumns.RELATIVE_PATH, Environment.DIRECTORY_DOCUMENTS + "/WeForza")
        } else {
            contentValues.put(MediaStore.Files.FileColumns.DATA, filePath)
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
}