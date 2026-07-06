import pdfDecryptService from './pdfDecryptService.js';
import pdfParserService from './pdfParserService.js';

/**
 * Orchestrates the full statement import pipeline:
 * 1. Decrypts and extracts text from password-protected PDF
 * 2. Identifies strategy and parses text into transactions
 * @param {Buffer} pdfBuffer 
 * @param {string} password 
 * @returns {Promise<Object>} Object containing bank details and transactions list
 */
export const importStatement = async (pdfBuffer, password) => {
  if (!pdfBuffer) {
    const error = new Error('PDF file buffer is required.');
    error.statusCode = 400;
    throw error;
  }
  
  if (!password) {
    const error = new Error('Password is required.');
    error.statusCode = 400;
    throw error;
  }

  // 1. Decrypt and extract text from the PDF
  const extractedText = await pdfDecryptService.decryptAndExtractText(pdfBuffer, password);

  // 2. Parse the extracted text into structured transaction list
  const parseResult = await pdfParserService.parseStatement(extractedText);

  return parseResult;
};

export default {
  importStatement,
};
