class FilesController < ApplicationController
    require 'azure/storage/blob'
    require 'zip'

    def upload_file
        local_path = params[:local_path]
        file_name = params[:file_name]

        if local_path and file_name
            uri = upload_to_azure(local_path, file_name)
            render json: { message: "File uploaded", url: uri }, status: :ok
        else
            render json: { error: "Missing params" }, status: :unprocessable_entity
        end
    end

    private

    def zip_folder(folder_path, zip_path, folder_app_name, app_name, timestamp)
        RunCommand.perform_async(["zip -r #{zip_path} #{app_name}/"], folder_path, folder_path, timestamp, true)
    end

    def upload_to_azure(local_path, file_name)
        timestamp = Time.now.to_i
        # Set your Azure Blob Storage connection string
        connection_string = 'DefaultEndpointsProtocol=https;AccountName=hotspotweb;AccountKey=1K2Rpcq2V3LZjVlFfTtvJt7mxiQ/XcKDMtrO1y0G/LOWu6607qUe+3hNeYuoFSsSIrzprCLB7yV7+AStVaXRFw==;EndpointSuffix=core.windows.net'

        # Set the Azure Blob Storage container and blob names
        container_name = 'hotspotweb-applications'
        blob_name = "#{file_name}_#{timestamp}.zip"

        # Set the local folder path to upload
        folder_path = local_path + file_name

        # Zip the folder
        zip_file_path = "#{local_path}#{file_name}_#{timestamp}.zip"
        zip_folder(local_path, zip_file_path, folder_path, file_name, timestamp)

        # Wait for the zip to finish
        sleep(10)

        # Create a BlobService object
        blob_service = Azure::Storage::Blob::BlobService.create_from_connection_string(connection_string)

        # Upload the zip file to Azure Blob Storage
        blob_service.create_block_blob(container_name, blob_name, File.open(zip_file_path, 'rb'))

        # Delete the local zip file
        File.delete(zip_file_path)

        # Return the URI of the uploaded file
        blob_service.generate_uri("#{container_name}/#{blob_name}")
    end
end
