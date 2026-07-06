import * as pdfjsLib from 'pdfjs-dist/legacy/build/pdf.mjs';
import { createRequire } from 'module';

const require = createRequire(import.meta.url);

// Set worker path for pdfjs-dist in Node environment
try {
  pdfjsLib.GlobalWorkerOptions.workerSrc = require.resolve('pdfjs-dist/legacy/build/pdf.worker.mjs');
} catch (e) {
  console.error('Failed to set pdfjs workerSrc:', e);
}

/**
 * Decrypts a password-protected PDF and extracts all text page by page.
 * @param {Buffer} pdfBuffer 
 * @param {string} password 
 * @returns {Promise<string>} Extracted text
 */
export const decryptAndExtractText = async (pdfBuffer, password) => {
  try {
    const loadingTask = pdfjsLib.getDocument({
      data: new Uint8Array(pdfBuffer),
      password: password,
      useSystemFonts: true,
      disableFontFace: true,
    });

    const doc = await loadingTask.promise;
    let fullText = '';

    for (let i = 1; i <= doc.numPages; i++) {
      const page = await doc.getPage(i);
      const textContent = await page.getTextContent();
      const pageText = textContent.items.map(item => item.str).join(' ');
      fullText += pageText + '\n';
    }

    return fullText;
  } catch (error) {
    if (error.name === 'PasswordException' || error.message?.includes('password') || error.code === 2) {
      const decryptError = new Error('Invalid PDF password');
      decryptError.statusCode = 400;
      throw decryptError;
    }
    const otherError = new Error(error.message || 'Failed to decrypt/parse PDF');
    otherError.statusCode = 400;
    throw otherError;
  }
};

export default {
  decryptAndExtractText,
};
