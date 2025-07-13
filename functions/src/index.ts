import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";
import {GenerativeModel, GoogleGenerativeAI} from "@google/generative-ai";

admin.initializeApp();

export const generateProjectIdeas = functions.runWith({secrets: ["GEMINI_API_KEY"]})
  .https.onCall(async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "The function must be called while authenticated.",
      );
    }

    const keywords = data.keywords as string;
    if (!keywords || keywords.trim().length === 0) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "The function must be called with a 'keywords' argument.",
      );
    }

    try {
      const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY!);
      const model: GenerativeModel = genAI.getGenerativeModel({model: "gemini-1.5-flash"});

      const prompt = `
        Based on the following keywords: "${keywords}", generate exactly 3 creative and feasible project ideas for a student tech community.
        
        VERY IMPORTANT: Your response must be a valid JSON array string. Do not include any text before or after the JSON array.
        
        The JSON array should contain 3 objects. Each object must have the following keys: "projectName", "problemStatement", "proposedSolution", and "keyFeatures" (which should be an array of strings).

        Example Format:
        [
          {
            "projectName": "Example Project Name",
            "problemStatement": "A clear problem statement.",
            "proposedSolution": "A concise proposed solution.",
            "keyFeatures": ["Feature A", "Feature B", "Feature C"]
          }
        ]
      `;

      const result = await model.generateContent(prompt);
      const response = await result.response;
      const responseText = response.text();

      console.log("Raw Gemini Response:", responseText);

      // --- START OF THE DEFINITIVE FIX ---

      let jsonString = "";

      // 1. First, try to find a markdown-fenced JSON block.
      const markdownMatch = responseText.match(/```json\s*([\s\S]*?)\s*```/);

      if (markdownMatch && markdownMatch[1]) {
        // If we find a markdown block, we exclusively use what's inside it.
        jsonString = markdownMatch[1];
      } else {
        // 2. If no markdown block is found, assume the response contains the JSON directly.
        // We will find the content between the first '[' and the last ']'.
        const startIndex = responseText.indexOf('[');
        const endIndex = responseText.lastIndexOf(']');

        if (startIndex !== -1 && endIndex !== -1) {
          jsonString = responseText.substring(startIndex, endIndex + 1);
        } else {
          // If we can't find a JSON array, we throw an error.
          console.error("Could not find a valid JSON array in the AI response.", responseText);
          throw new functions.https.HttpsError(
            "internal",
            "The AI response did not contain a readable JSON array.",
          );
        }
      }

      // 3. Parse the clean, extracted JSON string.
      const ideas = JSON.parse(jsonString);

      // --- END OF THE DEFINITIVE FIX ---

      return {ideas: ideas};
    } catch (error) {
      if (error instanceof SyntaxError) {
        console.error("Failed to parse JSON from extracted string:", error);
        throw new functions.https.HttpsError("internal", "Failed to parse the AI's JSON response.");
      }
      console.error("Error calling Gemini API:", error);
      throw new functions.https.HttpsError(
        "internal",
        "An unknown error occurred while generating project ideas.",
        error,
      );
    }
  });