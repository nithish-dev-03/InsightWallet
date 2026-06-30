import { v2 as cloudinary } from 'cloudinary';
import streamifier from 'streamifier';
import env from '../config/env.js';

cloudinary.config({
  cloud_name: env.cloudinaryCloudName,
  api_key: env.cloudinaryApiKey,
  api_secret: env.cloudinaryApiSecret,
});

class CloudinaryService {
  async uploadImage(buffer, options = {}) {
    return new Promise((resolve, reject) => {
      const uploadStream = cloudinary.uploader.upload_stream(
        {
          folder: options.folder || 'insightwallet',
          ...options,
        },
        (error, result) => {
          if (error) reject(error);
          else resolve(result);
        }
      );
      streamifier.createReadStream(buffer).pipe(uploadStream);
    });
  }

  async deleteImage(publicId) {
    return cloudinary.uploader.destroy(publicId);
  }
}

export default new CloudinaryService();
