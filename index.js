import express from "express";
import cors from "cors";
import axios from "axios";
import path from "path";
import { fileURLToPath } from "url";
import dotenv from "dotenv";
dotenv.config();

const SECRET_KEY = "UsmanBay7223@";

// 🔥 MIDDLEWARE (YAHAN)
app.use((req, res, next) => {
  const key = req.headers["x-api-key"];

  if (key !== SECRET_KEY) {
    return res.status(403).json({ error: "Unauthorized" });
  }

  next();
});

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config({ path: path.join(__dirname, ".env") });

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

const API_KEY = process.env.GEMINI_API_KEY;
const GEMINI_URL =
  `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${API_KEY}`;

/* -----------------------------------
   HELPERS
----------------------------------- */

async function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function askGeminiText(prompt, retries = 3) {
  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      const response = await axios.post(GEMINI_URL, {
        contents: [{ parts: [{ text: prompt }] }],
        generationConfig: {
          temperature: 0.8,
          topP: 0.95,
          topK: 40,
          maxOutputTokens: 1600,
        },
      });

      const data = response.data;
      return data?.candidates?.[0]?.content?.parts?.[0]?.text || "No response generated.";
    } catch (error) {
      const status = error?.response?.status;
      if ((status === 503 || status === 429) && attempt < retries) {
        await sleep(attempt * 3000);
        continue;
      }
      throw error;
    }
  }
}



function normalizeField(field = "") {
  const f = String(field).toLowerCase();

  if (f.includes("pre-engineering") || f.includes("engineering")) return "Pre-Engineering";
  if (f.includes("ics") || f.includes("computer")) return "ICS";
  if (f.includes("pre-medical") || f.includes("medical") || f.includes("biology")) return "Pre-Medical";
  if (f.includes("icom") || f.includes("commerce")) return "ICOM";
  if (f.includes("fa") || f.includes("arts")) return "FA";

  return field || "General";
}

function shuffleArray(arr) {
  const copy = [...arr];
  for (let i = copy.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [copy[i], copy[j]] = [copy[j], copy[i]];
  }
  return copy;
}

function pickRandom(arr, count) {
  return shuffleArray(arr).slice(0, count);
}

function buildQuestion(id, question, options, scoring, category) {
  return {
    id,
    question,
    options,
    scoring,
    category,
  };
}

function extractJsonFromText(text = "") {
  const cleaned = String(text).trim();

  // direct JSON
  try {
    return JSON.parse(cleaned);
  } catch (_) {}

  // markdown fenced JSON
  const fencedMatch = cleaned.match(/```json\s*([\s\S]*?)\s*```/i);
  if (fencedMatch) {
    try {
      return JSON.parse(fencedMatch[1]);
    } catch (_) {}
  }

  // first array in text
  const arrayMatch = cleaned.match(/\[[\s\S]*\]/);
  if (arrayMatch) {
    try {
      return JSON.parse(arrayMatch[0]);
    } catch (_) {}
  }

  throw new Error("AI response is not valid JSON");
}

function normalizeQuestionKey(text = "") {
  return String(text)
    .toLowerCase()
    .replace(/[^a-z0-9\s]/g, "")
    .replace(/\s+/g, " ")
    .trim();
}

function pickUniqueQuestions(arr, count) {
  const shuffled = shuffleArray(arr);
  const seen = new Set();
  const result = [];

  for (const item of shuffled) {
    const key = normalizeQuestionKey(item[0] || item.question || "");
    if (!seen.has(key)) {
      seen.add(key);
      result.push(item);
    }
    if (result.length === count) break;
  }

  return result;
}

function getQuizTargets(field = "General") {
  const normalized = normalizeField(field);

  const targetsMap = {
    "Pre-Engineering": [
      "Civil Engineering",
      "Electrical Engineering",
      "Mechanical Engineering",
      "Software Engineering",
      "Architecture",
    ],
    "ICS": [
      "Computer Science",
      "Software Engineering",
      "Data Science",
      "Cyber Security",
      "Artificial Intelligence",
    ],
    "Pre-Medical": [
      "MBBS",
      "BDS",
      "Pharm-D",
      "DPT",
      "Biotechnology",
    ],
    "ICOM": [
      "BBA",
      "Accounting and Finance",
      "Marketing",
      "Economics",
      "Banking",
    ],
    "FA": [
      "Psychology",
      "English",
      "Media Studies",
      "International Relations",
      "Education",
    ],
  };

  return targetsMap[normalized] || targetsMap["ICS"];
}

function validateDynamicQuiz(quiz, targets) {
  if (!Array.isArray(quiz) || quiz.length !== 30) {
    return false;
  }

  const seen = new Set();

  for (const q of quiz) {
    if (!q || typeof q !== "object") return false;
    if (!q.id || !q.question || !Array.isArray(q.options)) return false;
    if (q.options.length !== 4) return false;
    if (!q.scoring || typeof q.scoring !== "object") return false;
    if (!q.category || !["field", "personality"].includes(q.category)) return false;

    const key = normalizeQuestionKey(q.question);
    if (seen.has(key)) return false;
    seen.add(key);

    for (let i = 0; i < 4; i++) {
      const optionScore = q.scoring[String(i)];
      if (!optionScore || typeof optionScore !== "object") return false;

      let hasAnyTarget = false;
      for (const target of targets) {
        const value = Number(optionScore[target] || 0);
        if (!Number.isFinite(value)) return false;
        if (value > 0) hasAnyTarget = true;
      }

      if (!hasAnyTarget) return false;
    }
  }

  return true;
}

async function generateDynamicQuizWithAI(field = "General", educationLevel = "Unknown") {
  const normalized = normalizeField(field);
  const targets = getQuizTargets(normalized);

  const prompt = `
You are generating a career quiz for a student.

Student context:
- Education level: ${educationLevel}
- Current field/background: ${normalized}

Target recommendation fields:
${targets.map((t, i) => `${i + 1}. ${t}`).join("\n")}

Task:
Generate EXACTLY 30 UNIQUE multiple-choice questions in ENGLISH.
- 15 questions must have category = "field"
- 15 questions must have category = "personality"
- Every question must be clearly different from the others
- Do NOT repeat the same concept with slightly different wording
- Each question must have exactly 4 options
- Each option must contribute score to one or more target fields
- Scoring values should usually be between 0 and 3
- Make questions practical, student-friendly, and specific
- The quiz must help differentiate among the target fields
- Questions must match the student's background
- Avoid generic repeated questions like "Which career do you like?" again and again

Return ONLY valid JSON array.
No markdown.
No explanation.

Use this exact JSON structure for each item:
{
  "id": "q1",
  "question": "Question text",
  "options": ["Option A", "Option B", "Option C", "Option D"],
  "category": "field",
  "scoring": {
    "0": {"${targets[0]}": 3, "${targets[1]}": 0, "${targets[2]}": 0, "${targets[3]}": 0, "${targets[4]}": 0},
    "1": {"${targets[0]}": 0, "${targets[1]}": 3, "${targets[2]}": 0, "${targets[3]}": 0, "${targets[4]}": 0},
    "2": {"${targets[0]}": 0, "${targets[1]}": 0, "${targets[2]}": 3, "${targets[3]}": 0, "${targets[4]}": 0},
    "3": {"${targets[0]}": 0, "${targets[1]}": 0, "${targets[2]}": 0, "${targets[3]}": 3, "${targets[4]}": 1}
  }
}
`;

  const raw = await askGeminiText(prompt, 3);
  const parsed = extractJsonFromText(raw);

  if (!validateDynamicQuiz(parsed, targets)) {
    throw new Error("AI quiz validation failed");
  }

  return parsed.map((q, index) => ({
    id: `${q.id || `q_${index + 1}`}_${Date.now()}_${Math.floor(Math.random() * 100000)}`,
    question: q.question,
    options: q.options,
    scoring: q.scoring,
    category: q.category,
  }));
}


/* -----------------------------------
   QUESTION BANKS
----------------------------------- */

const quizBanks = {
  "Pre-Engineering": {
    targets: [
      "Civil Engineering",
      "Electrical Engineering",
      "Mechanical Engineering",
      "Software Engineering",
      "Architecture",
    ],
    fieldQuestions: [
      [
        "Which type of engineering project sounds most interesting to you?",
        [
          "Building bridges, roads, and structures",
          "Working with circuits and electrical systems",
          "Designing machines and mechanical systems",
          "Creating software and digital systems",
        ],
        {
          "0": { "Civil Engineering": 3 },
          "1": { "Electrical Engineering": 3 },
          "2": { "Mechanical Engineering": 3 },
          "3": { "Software Engineering": 3 },
        },
      ],
      [
        "Which subject area attracts you the most?",
        [
          "Structures and construction",
          "Power systems and electronics",
          "Machines and manufacturing",
          "Programming and software",
        ],
        {
          "0": { "Civil Engineering": 3, "Architecture": 1 },
          "1": { "Electrical Engineering": 3 },
          "2": { "Mechanical Engineering": 3 },
          "3": { "Software Engineering": 3 },
        },
      ],
      [
        "Which working environment do you prefer most?",
        [
          "Construction sites and structural projects",
          "Labs and electrical testing environments",
          "Workshops and mechanical systems",
          "Computer labs and software teams",
        ],
        {
          "0": { "Civil Engineering": 3, "Architecture": 1 },
          "1": { "Electrical Engineering": 3 },
          "2": { "Mechanical Engineering": 3 },
          "3": { "Software Engineering": 3 },
        },
      ],
      [
        "What kind of technical problem would you enjoy solving most?",
        [
          "How to make a structure stronger and safer",
          "How to improve a power or control system",
          "How to improve machine performance",
          "How to improve an app or software system",
        ],
        {
          "0": { "Civil Engineering": 3, "Architecture": 1 },
          "1": { "Electrical Engineering": 3 },
          "2": { "Mechanical Engineering": 3 },
          "3": { "Software Engineering": 3 },
        },
      ],
      [
        "Which result would make you feel most accomplished?",
        [
          "A completed building or road project",
          "A working electrical system",
          "A high-performance machine",
          "A successful software product",
        ],
        {
          "0": { "Civil Engineering": 3, "Architecture": 1 },
          "1": { "Electrical Engineering": 3 },
          "2": { "Mechanical Engineering": 3 },
          "3": { "Software Engineering": 3 },
        },
      ],
      [
        "Which kind of design work interests you most?",
        [
          "Structural and construction design",
          "Circuit and electrical system design",
          "Mechanical part and machine design",
          "Software architecture and app design",
        ],
        {
          "0": { "Civil Engineering": 3, "Architecture": 2 },
          "1": { "Electrical Engineering": 3 },
          "2": { "Mechanical Engineering": 3 },
          "3": { "Software Engineering": 3 },
        },
      ],
      [
        "Which future role sounds best to you?",
        [
          "Civil engineer",
          "Electrical engineer",
          "Mechanical engineer",
          "Software engineer",
        ],
        {
          "0": { "Civil Engineering": 3 },
          "1": { "Electrical Engineering": 3 },
          "2": { "Mechanical Engineering": 3 },
          "3": { "Software Engineering": 3 },
        },
      ],
      [
        "Which challenge feels most appealing?",
        [
          "Planning and managing infrastructure",
          "Improving electrical reliability",
          "Designing efficient mechanical systems",
          "Building useful digital products",
        ],
        {
          "0": { "Civil Engineering": 3, "Architecture": 1 },
          "1": { "Electrical Engineering": 3 },
          "2": { "Mechanical Engineering": 3 },
          "3": { "Software Engineering": 3 },
        },
      ],
      [
        "Which area do you want to explore more deeply?",
        [
          "Construction and urban development",
          "Electronics and electrical control",
          "Mechanics and industrial systems",
          "Software and intelligent applications",
        ],
        {
          "0": { "Civil Engineering": 3, "Architecture": 2 },
          "1": { "Electrical Engineering": 3 },
          "2": { "Mechanical Engineering": 3 },
          "3": { "Software Engineering": 3 },
        },
      ],
      [
        "Which of these sounds most natural to you?",
        [
          "Understanding buildings and public infrastructure",
          "Understanding current, voltage, and systems",
          "Understanding movement, force, and machines",
          "Understanding logic, code, and software systems",
        ],
        {
          "0": { "Civil Engineering": 3, "Architecture": 1 },
          "1": { "Electrical Engineering": 3 },
          "2": { "Mechanical Engineering": 3 },
          "3": { "Software Engineering": 3 },
        },
      ],
      [
        "If given a final year project, what would you choose?",
        [
          "A smart bridge or building concept",
          "An automated electrical control system",
          "A machine design or mechanical prototype",
          "A software or mobile app solution",
        ],
        {
          "0": { "Civil Engineering": 3, "Architecture": 2 },
          "1": { "Electrical Engineering": 3 },
          "2": { "Mechanical Engineering": 3 },
          "3": { "Software Engineering": 3 },
        },
      ],
      [
        "Which branch feels closest to your strengths?",
        [
          "Civil and structural thinking",
          "Electrical systems thinking",
          "Mechanical systems thinking",
          "Computing and software thinking",
        ],
        {
          "0": { "Civil Engineering": 3, "Architecture": 1 },
          "1": { "Electrical Engineering": 3 },
          "2": { "Mechanical Engineering": 3 },
          "3": { "Software Engineering": 3 },
        },
      ],
      [
        "What kind of engineering impact would you like to make?",
        [
          "Better infrastructure for society",
          "More efficient power and electronics",
          "Better machines and industrial solutions",
          "Better digital products and software",
        ],
        {
          "0": { "Civil Engineering": 3, "Architecture": 1 },
          "1": { "Electrical Engineering": 3 },
          "2": { "Mechanical Engineering": 3 },
          "3": { "Software Engineering": 3 },
        },
      ],
      [
        "Which option feels most exciting for higher studies?",
        [
          "Civil / Architecture related studies",
          "Electrical and electronics studies",
          "Mechanical and manufacturing studies",
          "Software and computing studies",
        ],
        {
          "0": { "Civil Engineering": 2, "Architecture": 3 },
          "1": { "Electrical Engineering": 3 },
          "2": { "Mechanical Engineering": 3 },
          "3": { "Software Engineering": 3 },
        },
      ],
      [
        "Which project style appeals to you most?",
        [
          "Large visible physical structures",
          "Smart electrical systems",
          "Mechanical problem solving",
          "Digital solutions and systems",
        ],
        {
          "0": { "Civil Engineering": 3, "Architecture": 2 },
          "1": { "Electrical Engineering": 3 },
          "2": { "Mechanical Engineering": 3 },
          "3": { "Software Engineering": 3 },
        },
      ],
    ],
    personalityQuestions: [
      [
        "Which work style fits you best?",
        [
          "Outdoor, practical, project-based work",
          "Technical system analysis",
          "Hands-on mechanical and physical systems",
          "Computer-based problem solving",
        ],
        {
          "0": { "Civil Engineering": 2, "Architecture": 1 },
          "1": { "Electrical Engineering": 2 },
          "2": { "Mechanical Engineering": 2 },
          "3": { "Software Engineering": 2 },
        },
      ],
      [
        "Which type of challenge do you enjoy more?",
        [
          "Planning and executing large projects",
          "Troubleshooting technical systems",
          "Improving machine function",
          "Solving logic-based digital issues",
        ],
        {
          "0": { "Civil Engineering": 2, "Architecture": 1 },
          "1": { "Electrical Engineering": 2 },
          "2": { "Mechanical Engineering": 2 },
          "3": { "Software Engineering": 2 },
        },
      ],
      [
        "What kind of achievement feels most meaningful to you?",
        [
          "A visible impact on society through infrastructure",
          "A reliable and efficient technical system",
          "A machine working better than before",
          "A software product helping users",
        ],
        {
          "0": { "Civil Engineering": 2, "Architecture": 1 },
          "1": { "Electrical Engineering": 2 },
          "2": { "Mechanical Engineering": 2 },
          "3": { "Software Engineering": 2 },
        },
      ],
      [
        "Which trait describes you best?",
        [
          "Organized and practical",
          "Analytical and system-oriented",
          "Hands-on and process-focused",
          "Logical and digital-minded",
        ],
        {
          "0": { "Civil Engineering": 2, "Architecture": 1 },
          "1": { "Electrical Engineering": 2 },
          "2": { "Mechanical Engineering": 2 },
          "3": { "Software Engineering": 2 },
        },
      ],
      [
        "What would you rather spend time learning?",
        [
          "Construction planning and structural concepts",
          "Electrical and electronic systems",
          "Machines, mechanics, and production",
          "Programming, apps, and software design",
        ],
        {
          "0": { "Civil Engineering": 2, "Architecture": 1 },
          "1": { "Electrical Engineering": 2 },
          "2": { "Mechanical Engineering": 2 },
          "3": { "Software Engineering": 2 },
        },
      ],
      [
        "Which long-term role sounds most natural to you?",
        [
          "Project / site engineer",
          "Electrical systems engineer",
          "Mechanical design engineer",
          "Software developer / engineer",
        ],
        {
          "0": { "Civil Engineering": 3 },
          "1": { "Electrical Engineering": 3 },
          "2": { "Mechanical Engineering": 3 },
          "3": { "Software Engineering": 3 },
        },
      ],
      [
        "Which environment motivates you most?",
        [
          "Infrastructure and urban development",
          "Power systems and devices",
          "Machines and industrial systems",
          "Technology companies and digital products",
        ],
        {
          "0": { "Civil Engineering": 2, "Architecture": 2 },
          "1": { "Electrical Engineering": 2 },
          "2": { "Mechanical Engineering": 2 },
          "3": { "Software Engineering": 2 },
        },
      ],
      [
        "Which kind of output would make you happiest?",
        [
          "A completed structure or design",
          "A stable electrical setup",
          "A better machine or mechanism",
          "A useful digital product",
        ],
        {
          "0": { "Civil Engineering": 2, "Architecture": 2 },
          "1": { "Electrical Engineering": 2 },
          "2": { "Mechanical Engineering": 2 },
          "3": { "Software Engineering": 2 },
        },
      ],
      [
        "Which combination fits you best?",
        [
          "Planning + physical development",
          "Technology + systems",
          "Machines + motion",
          "Logic + code",
        ],
        {
          "0": { "Civil Engineering": 2, "Architecture": 1 },
          "1": { "Electrical Engineering": 2 },
          "2": { "Mechanical Engineering": 2 },
          "3": { "Software Engineering": 2 },
        },
      ],
      [
        "Which statement sounds closest to your mindset?",
        [
          "I like seeing physical results of my work",
          "I enjoy technical systems working correctly",
          "I enjoy improving machines and practical tools",
          "I enjoy building digital systems and apps",
        ],
        {
          "0": { "Civil Engineering": 2, "Architecture": 2 },
          "1": { "Electrical Engineering": 2 },
          "2": { "Mechanical Engineering": 2 },
          "3": { "Software Engineering": 2 },
        },
      ],
      [
        "What kind of learning excites you more?",
        [
          "Large-scale design and infrastructure",
          "Devices, energy, and control systems",
          "Mechanics and manufacturing systems",
          "Software engineering and modern computing",
        ],
        {
          "0": { "Civil Engineering": 2, "Architecture": 2 },
          "1": { "Electrical Engineering": 2 },
          "2": { "Mechanical Engineering": 2 },
          "3": { "Software Engineering": 2 },
        },
      ],
      [
        "What do you prefer to create?",
        [
          "Structures and spaces",
          "Electrical solutions",
          "Mechanical solutions",
          "Software products",
        ],
        {
          "0": { "Civil Engineering": 2, "Architecture": 3 },
          "1": { "Electrical Engineering": 2 },
          "2": { "Mechanical Engineering": 2 },
          "3": { "Software Engineering": 2 },
        },
      ],
      [
        "Which field feels closest to your natural curiosity?",
        [
          "Civil / Architecture",
          "Electrical systems",
          "Mechanical systems",
          "Software and computing",
        ],
        {
          "0": { "Civil Engineering": 2, "Architecture": 2 },
          "1": { "Electrical Engineering": 2 },
          "2": { "Mechanical Engineering": 2 },
          "3": { "Software Engineering": 2 },
        },
      ],
      [
        "What kind of work would you repeat happily for years?",
        [
          "Designing and managing structures",
          "Optimizing electrical systems",
          "Improving machines and industrial tools",
          "Building and maintaining software systems",
        ],
        {
          "0": { "Civil Engineering": 2, "Architecture": 2 },
          "1": { "Electrical Engineering": 2 },
          "2": { "Mechanical Engineering": 2 },
          "3": { "Software Engineering": 2 },
        },
      ],
      [
        "Which career outcome sounds best to you?",
        [
          "Civil engineer or architect",
          "Electrical engineer",
          "Mechanical engineer",
          "Software engineer",
        ],
        {
          "0": { "Civil Engineering": 2, "Architecture": 3 },
          "1": { "Electrical Engineering": 3 },
          "2": { "Mechanical Engineering": 3 },
          "3": { "Software Engineering": 3 },
        },
      ],
    ],
  },

  "ICS": {
    targets: [
      "Computer Science",
      "Software Engineering",
      "Data Science",
      "Cyber Security",
      "Artificial Intelligence",
    ],
    fieldQuestions: [
      [
        "Which area interests you most?",
        [
          "Core computing and algorithms",
          "Building software systems and apps",
          "Working with data and insights",
          "Creating intelligent systems",
        ],
        {
          "0": { "Computer Science": 3 },
          "1": { "Software Engineering": 3 },
          "2": { "Data Science": 3 },
          "3": { "Artificial Intelligence": 3 },
        },
      ],
      [
        "What kind of technical problem would you enjoy most?",
        [
          "Algorithm and system logic problems",
          "Software architecture and application problems",
          "Data analysis and pattern discovery",
          "Training smart models and prediction systems",
        ],
        {
          "0": { "Computer Science": 3 },
          "1": { "Software Engineering": 3 },
          "2": { "Data Science": 3 },
          "3": { "Artificial Intelligence": 3 },
        },
      ],
      [
        "Which project would you choose first?",
        [
          "A core computing logic project",
          "A complete web or mobile application",
          "A dashboard using real-world data",
          "An AI chatbot or recommendation engine",
        ],
        {
          "0": { "Computer Science": 3 },
          "1": { "Software Engineering": 3 },
          "2": { "Data Science": 3 },
          "3": { "Artificial Intelligence": 3 },
        },
      ],
      [
        "Which subject combination feels strongest for you?",
        [
          "Logic and algorithms",
          "Software design and development",
          "Statistics and data interpretation",
          "Machine learning and automation",
        ],
        {
          "0": { "Computer Science": 3 },
          "1": { "Software Engineering": 3 },
          "2": { "Data Science": 3 },
          "3": { "Artificial Intelligence": 3 },
        },
      ],
      [
        "Which future role sounds best?",
        [
          "Computer scientist",
          "Software engineer",
          "Data scientist",
          "AI engineer",
        ],
        {
          "0": { "Computer Science": 3 },
          "1": { "Software Engineering": 3 },
          "2": { "Data Science": 3 },
          "3": { "Artificial Intelligence": 3 },
        },
      ],
      [
        "What excites you more?",
        [
          "How systems work internally",
          "How software helps users",
          "How data reveals insights",
          "How machines can learn and decide",
        ],
        {
          "0": { "Computer Science": 3 },
          "1": { "Software Engineering": 3 },
          "2": { "Data Science": 3 },
          "3": { "Artificial Intelligence": 3 },
        },
      ],
      [
        "Which challenge sounds most appealing?",
        [
          "Optimizing computing logic",
          "Developing large software systems",
          "Finding hidden patterns in data",
          "Building predictive models",
        ],
        {
          "0": { "Computer Science": 3 },
          "1": { "Software Engineering": 3 },
          "2": { "Data Science": 3 },
          "3": { "Artificial Intelligence": 3 },
        },
      ],
      [
        "Which learning path do you want to go deeper into?",
        [
          "Programming fundamentals and theory",
          "Software development lifecycle",
          "Data analysis and visualization",
          "AI and machine learning",
        ],
        {
          "0": { "Computer Science": 3 },
          "1": { "Software Engineering": 3 },
          "2": { "Data Science": 3 },
          "3": { "Artificial Intelligence": 3 },
        },
      ],
      [
        "What feels more natural to you?",
        [
          "Understanding systems deeply",
          "Building applications for users",
          "Working with numbers and patterns",
          "Creating smart automated systems",
        ],
        {
          "0": { "Computer Science": 3 },
          "1": { "Software Engineering": 3 },
          "2": { "Data Science": 3 },
          "3": { "Artificial Intelligence": 3 },
        },
      ],
      [
        "Which outcome would make you most proud?",
        [
          "A strong computing solution",
          "A successful software product",
          "A useful data insight or model",
          "An intelligent AI system",
        ],
        {
          "0": { "Computer Science": 3 },
          "1": { "Software Engineering": 3 },
          "2": { "Data Science": 3 },
          "3": { "Artificial Intelligence": 3 },
        },
      ],
      [
        "Which digital role feels closest to you?",
        [
          "Systems and computing specialist",
          "Application/software builder",
          "Data problem solver",
          "AI solution creator",
        ],
        {
          "0": { "Computer Science": 3 },
          "1": { "Software Engineering": 3 },
          "2": { "Data Science": 3 },
          "3": { "Artificial Intelligence": 3 },
        },
      ],
      [
        "Which topic would you choose for a long project?",
        [
          "Algorithms and system concepts",
          "Software product development",
          "Data-driven decision making",
          "Intelligent automation",
        ],
        {
          "0": { "Computer Science": 3 },
          "1": { "Software Engineering": 3 },
          "2": { "Data Science": 3 },
          "3": { "Artificial Intelligence": 3 },
        },
      ],
      [
        "Which type of problem would you happily solve repeatedly?",
        [
          "Logic and core system issues",
          "User software and application issues",
          "Data cleaning and analysis issues",
          "Model training and AI accuracy issues",
        ],
        {
          "0": { "Computer Science": 3 },
          "1": { "Software Engineering": 3 },
          "2": { "Data Science": 3 },
          "3": { "Artificial Intelligence": 3 },
        },
      ],
      [
        "Which of these sounds most exciting for university?",
        [
          "Computer science theory and systems",
          "Software engineering practice",
          "Data science and analytics",
          "Artificial intelligence and ML",
        ],
        {
          "0": { "Computer Science": 3 },
          "1": { "Software Engineering": 3 },
          "2": { "Data Science": 3 },
          "3": { "Artificial Intelligence": 3 },
        },
      ],
      [
        "Which technology path attracts you most?",
        [
          "Core computing",
          "Software systems",
          "Data analysis",
          "AI applications",
        ],
        {
          "0": { "Computer Science": 3, "Cyber Security": 1 },
          "1": { "Software Engineering": 3 },
          "2": { "Data Science": 3 },
          "3": { "Artificial Intelligence": 3 },
        },
      ],
    ],
    personalityQuestions: [
      [
        "Which work style fits you best?",
        [
          "Deep technical thinking",
          "Building systems for users",
          "Analyzing information and trends",
          "Experimenting with intelligent systems",
        ],
        {
          "0": { "Computer Science": 2, "Cyber Security": 1 },
          "1": { "Software Engineering": 2 },
          "2": { "Data Science": 2 },
          "3": { "Artificial Intelligence": 2 },
        },
      ],
      [
        "What kind of result satisfies you most?",
        [
          "A technically elegant solution",
          "A polished working product",
          "A useful data insight",
          "A smart automated outcome",
        ],
        {
          "0": { "Computer Science": 2 },
          "1": { "Software Engineering": 2 },
          "2": { "Data Science": 2 },
          "3": { "Artificial Intelligence": 2 },
        },
      ],
      [
        "What motivates you more?",
        [
          "Understanding how systems work",
          "Building something people can use",
          "Learning from data",
          "Teaching systems to think",
        ],
        {
          "0": { "Computer Science": 2, "Cyber Security": 1 },
          "1": { "Software Engineering": 2 },
          "2": { "Data Science": 2 },
          "3": { "Artificial Intelligence": 2 },
        },
      ],
      [
        "Which description matches you best?",
        [
          "Logical and technical",
          "Structured and product-focused",
          "Analytical and data-curious",
          "Innovative and experimental",
        ],
        {
          "0": { "Computer Science": 2, "Cyber Security": 1 },
          "1": { "Software Engineering": 2 },
          "2": { "Data Science": 2 },
          "3": { "Artificial Intelligence": 2 },
        },
      ],
      [
        "Which long-term path sounds best?",
        [
          "Computer science specialist",
          "Software engineer",
          "Data scientist",
          "AI engineer",
        ],
        {
          "0": { "Computer Science": 3, "Cyber Security": 1 },
          "1": { "Software Engineering": 3 },
          "2": { "Data Science": 3 },
          "3": { "Artificial Intelligence": 3 },
        },
      ],
      [
        "What would you like to keep improving for years?",
        [
          "Programming depth and core systems",
          "Application and software quality",
          "Data accuracy and interpretation",
          "AI models and intelligence",
        ],
        {
          "0": { "Computer Science": 2, "Cyber Security": 1 },
          "1": { "Software Engineering": 2 },
          "2": { "Data Science": 2 },
          "3": { "Artificial Intelligence": 2 },
        },
      ],
      [
        "Which type of project team fits you most?",
        [
          "Deep technical research team",
          "Software product team",
          "Data and analytics team",
          "AI innovation team",
        ],
        {
          "0": { "Computer Science": 2, "Cyber Security": 1 },
          "1": { "Software Engineering": 2 },
          "2": { "Data Science": 2 },
          "3": { "Artificial Intelligence": 2 },
        },
      ],
      [
        "What kind of digital impact do you prefer?",
        [
          "Stronger computing systems",
          "Better software experiences",
          "Better decisions from data",
          "Smarter automated solutions",
        ],
        {
          "0": { "Computer Science": 2, "Cyber Security": 1 },
          "1": { "Software Engineering": 2 },
          "2": { "Data Science": 2 },
          "3": { "Artificial Intelligence": 2 },
        },
      ],
      [
        "Which option sounds most natural to you?",
        [
          "Theory and system depth",
          "Practical software building",
          "Analysis and evidence",
          "Innovation and machine learning",
        ],
        {
          "0": { "Computer Science": 2, "Cyber Security": 1 },
          "1": { "Software Engineering": 2 },
          "2": { "Data Science": 2 },
          "3": { "Artificial Intelligence": 2 },
        },
      ],
      [
        "Which output would make you happiest?",
        [
          "A strong technical foundation",
          "A working real-world app",
          "A useful analytical report",
          "A smart AI-powered solution",
        ],
        {
          "0": { "Computer Science": 2, "Cyber Security": 1 },
          "1": { "Software Engineering": 2 },
          "2": { "Data Science": 2 },
          "3": { "Artificial Intelligence": 2 },
        },
      ],
      [
        "Which field feels closest to your mindset?",
        [
          "Computer science / cyber",
          "Software engineering",
          "Data science",
          "Artificial intelligence",
        ],
        {
          "0": { "Computer Science": 2, "Cyber Security": 2 },
          "1": { "Software Engineering": 2 },
          "2": { "Data Science": 2 },
          "3": { "Artificial Intelligence": 2 },
        },
      ],
      [
        "What kind of skills do you most want to use?",
        [
          "Technical logic and systems thinking",
          "Software product development",
          "Data interpretation and analytics",
          "ML and intelligent automation",
        ],
        {
          "0": { "Computer Science": 2, "Cyber Security": 1 },
          "1": { "Software Engineering": 2 },
          "2": { "Data Science": 2 },
          "3": { "Artificial Intelligence": 2 },
        },
      ],
      [
        "Which environment motivates you more?",
        [
          "Research and technical depth",
          "Development and product teams",
          "Business intelligence and analytics",
          "AI labs and innovation teams",
        ],
        {
          "0": { "Computer Science": 2, "Cyber Security": 1 },
          "1": { "Software Engineering": 2 },
          "2": { "Data Science": 2 },
          "3": { "Artificial Intelligence": 2 },
        },
      ],
      [
        "Which statement feels true for you?",
        [
          "I enjoy deep logical problems",
          "I enjoy making useful software",
          "I enjoy learning from data",
          "I enjoy smart, futuristic technologies",
        ],
        {
          "0": { "Computer Science": 2, "Cyber Security": 1 },
          "1": { "Software Engineering": 2 },
          "2": { "Data Science": 2 },
          "3": { "Artificial Intelligence": 2 },
        },
      ],
      [
        "Which career direction feels most exciting?",
        [
          "Computer science / cyber security",
          "Software engineering",
          "Data science",
          "Artificial intelligence",
        ],
        {
          "0": { "Computer Science": 2, "Cyber Security": 2 },
          "1": { "Software Engineering": 3 },
          "2": { "Data Science": 3 },
          "3": { "Artificial Intelligence": 3 },
        },
      ],
    ],
  },

  "Pre-Medical": {
    targets: ["MBBS", "BDS", "Pharm-D", "DPT", "Biotechnology"],
    fieldQuestions: [
      [
        "Which healthcare role attracts you most?",
        [
          "Doctor",
          "Dentist",
          "Pharmacist",
          "Physiotherapist",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
      [
        "Which type of work sounds most meaningful?",
        [
          "Diagnosing and treating patients",
          "Improving oral health",
          "Managing medicines and treatment safety",
          "Helping recovery through physical therapy",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
      [
        "Which field of science feels closest to you?",
        [
          "Clinical medicine",
          "Dental science",
          "Pharmaceutical science",
          "Rehabilitation science",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
      [
        "Which environment would you prefer?",
        [
          "Hospital and patient care",
          "Dental clinic",
          "Pharmacy and medication environment",
          "Therapy and rehabilitation center",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
      [
        "Which outcome would make you most proud?",
        [
          "Helping diagnose and treat illness",
          "Improving a patient’s dental health",
          "Ensuring correct medicine use",
          "Helping someone regain movement",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
      [
        "Which subject area sounds most exciting?",
        [
          "Human disease and treatment",
          "Teeth and oral care",
          "Drugs and medical formulations",
          "Body movement and rehabilitation",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
      [
        "Which future sounds best?",
        [
          "Medical doctor",
          "Dental specialist",
          "Clinical pharmacist",
          "Physical therapist",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
      [
        "Which contribution would you rather make?",
        [
          "Treating serious health conditions",
          "Improving smiles and dental care",
          "Improving medicine safety and effectiveness",
          "Improving physical recovery and mobility",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
      [
        "Which task feels most interesting?",
        [
          "Understanding symptoms and treatment",
          "Performing dental procedures",
          "Learning about drugs and dosages",
          "Designing therapy plans",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
      [
        "Which academic path seems most suitable?",
        [
          "Medicine",
          "Dentistry",
          "Pharmacy",
          "Physiotherapy",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
      [
        "Which science-based role also interests you?",
        [
          "Medical science",
          "Dental science",
          "Pharmaceutical research",
          "Biotechnology",
        ],
        {
          "0": { "MBBS": 2 },
          "1": { "BDS": 2 },
          "2": { "Pharm-D": 2 },
          "3": { "Biotechnology": 3 },
        },
      ],
      [
        "Which healthcare challenge would you prefer solving?",
        [
          "A patient’s illness",
          "A dental issue",
          "A medication-related issue",
          "A physical recovery issue",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
      [
        "Which kind of professional identity fits you more?",
        [
          "Clinical doctor",
          "Dental care specialist",
          "Medicine expert",
          "Recovery and movement specialist",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
      [
        "Which knowledge area are you most willing to study deeply?",
        [
          "Human disease and diagnosis",
          "Oral anatomy and dentistry",
          "Medicines and pharmacology",
          "Movement and rehabilitation",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
      [
        "Which path feels most aligned with your future?",
        [
          "MBBS",
          "BDS",
          "Pharm-D",
          "DPT",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
    ],
    personalityQuestions: [
      [
        "Which type of service appeals to you most?",
        [
          "Direct patient diagnosis and care",
          "Focused oral healthcare",
          "Medicines and treatment support",
          "Helping patients recover physically",
        ],
        {
          "0": { "MBBS": 2 },
          "1": { "BDS": 2 },
          "2": { "Pharm-D": 2 },
          "3": { "DPT": 2 },
        },
      ],
      [
        "Which trait describes you best?",
        [
          "Calm under clinical pressure",
          "Precise and careful",
          "Detail-oriented with treatments",
          "Supportive and patient-focused",
        ],
        {
          "0": { "MBBS": 2 },
          "1": { "BDS": 2 },
          "2": { "Pharm-D": 2 },
          "3": { "DPT": 2 },
        },
      ],
      [
        "Which environment suits you more?",
        [
          "Hospital or clinical setting",
          "Dental clinic setting",
          "Pharmacy or medicine setting",
          "Therapy and rehabilitation setting",
        ],
        {
          "0": { "MBBS": 2 },
          "1": { "BDS": 2 },
          "2": { "Pharm-D": 2 },
          "3": { "DPT": 2 },
        },
      ],
      [
        "Which statement sounds more like you?",
        [
          "I want to understand and treat health problems",
          "I want to improve oral care and dental health",
          "I want to work with medicines safely and effectively",
          "I want to help recovery and mobility",
        ],
        {
          "0": { "MBBS": 2 },
          "1": { "BDS": 2 },
          "2": { "Pharm-D": 2 },
          "3": { "DPT": 2 },
        },
      ],
      [
        "Which long-term role feels best?",
        [
          "Doctor",
          "Dentist",
          "Pharmacist",
          "Physiotherapist",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
      [
        "What type of impact matters most to you?",
        [
          "Treating disease",
          "Improving oral health",
          "Managing treatment through medicines",
          "Helping restore movement and quality of life",
        ],
        {
          "0": { "MBBS": 2 },
          "1": { "BDS": 2 },
          "2": { "Pharm-D": 2 },
          "3": { "DPT": 2 },
        },
      ],
      [
        "Which type of learning excites you more?",
        [
          "Clinical and patient-focused learning",
          "Dental and oral-focused learning",
          "Drug and medicine-focused learning",
          "Therapy and rehabilitation-focused learning",
        ],
        {
          "0": { "MBBS": 2 },
          "1": { "BDS": 2 },
          "2": { "Pharm-D": 2 },
          "3": { "DPT": 2 },
        },
      ],
      [
        "What kind of responsibility would you prefer?",
        [
          "Patient diagnosis and treatment decisions",
          "Dental treatment and procedures",
          "Medicine-related safety and guidance",
          "Physical recovery planning",
        ],
        {
          "0": { "MBBS": 2 },
          "1": { "BDS": 2 },
          "2": { "Pharm-D": 2 },
          "3": { "DPT": 2 },
        },
      ],
      [
        "Which professional identity sounds best?",
        [
          "Clinical healthcare professional",
          "Dental healthcare professional",
          "Pharmaceutical healthcare professional",
          "Rehabilitation professional",
        ],
        {
          "0": { "MBBS": 2 },
          "1": { "BDS": 2 },
          "2": { "Pharm-D": 2 },
          "3": { "DPT": 2 },
        },
      ],
      [
        "Which combination fits you best?",
        [
          "Care + diagnosis",
          "Precision + oral procedures",
          "Science + medicines",
          "Support + recovery",
        ],
        {
          "0": { "MBBS": 2 },
          "1": { "BDS": 2 },
          "2": { "Pharm-D": 2 },
          "3": { "DPT": 2 },
        },
      ],
      [
        "Which type of success would make you happiest?",
        [
          "Saving or improving a life through diagnosis",
          "Improving someone’s dental wellbeing",
          "Helping a patient through the right medicine",
          "Helping a patient walk or function better again",
        ],
        {
          "0": { "MBBS": 2 },
          "1": { "BDS": 2 },
          "2": { "Pharm-D": 2 },
          "3": { "DPT": 2 },
        },
      ],
      [
        "What kind of care feels closest to your personality?",
        [
          "General medical care",
          "Dental care",
          "Medication management",
          "Therapy and rehabilitation",
        ],
        {
          "0": { "MBBS": 2 },
          "1": { "BDS": 2 },
          "2": { "Pharm-D": 2 },
          "3": { "DPT": 2 },
        },
      ],
      [
        "Which future sounds most fulfilling?",
        [
          "Working in medicine",
          "Working in dentistry",
          "Working in pharmacy",
          "Working in physiotherapy",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
      [
        "Which path feels more natural to your strengths?",
        [
          "Medicine",
          "Dentistry",
          "Pharmacy",
          "Physiotherapy",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
      [
        "Which healthcare path would you most likely choose confidently?",
        [
          "MBBS",
          "BDS",
          "Pharm-D",
          "DPT",
        ],
        {
          "0": { "MBBS": 3 },
          "1": { "BDS": 3 },
          "2": { "Pharm-D": 3 },
          "3": { "DPT": 3 },
        },
      ],
    ],
  },

  "ICOM": {
    targets: ["BBA", "Accounting and Finance", "Marketing", "Economics", "Banking"],
    fieldQuestions: [
      [
        "Which business area interests you most?",
        [
          "Management and leadership",
          "Accounts and financial reporting",
          "Marketing and branding",
          "Economic analysis and policy",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 3 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
      [
        "Which role sounds most attractive?",
        [
          "Business manager",
          "Finance professional",
          "Marketing specialist",
          "Economist",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 3 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
      [
        "What kind of work do you enjoy most?",
        [
          "Managing teams and business decisions",
          "Handling numbers, budgets, and accounts",
          "Promoting products and communication",
          "Studying markets and trends",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 3, "Banking": 1 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
      [
        "Which environment fits you better?",
        [
          "Business operations and management",
          "Finance office and reporting",
          "Brand and sales campaigns",
          "Research and policy analysis",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 3, "Banking": 1 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
      [
        "Which task sounds most interesting?",
        [
          "Making business strategies",
          "Preparing financial statements",
          "Designing promotional campaigns",
          "Studying market behavior",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 3, "Banking": 1 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
      [
        "Which result would make you most proud?",
        [
          "A successful business plan",
          "Strong financial control",
          "A successful marketing campaign",
          "Useful economic insight",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 3, "Banking": 1 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
      [
        "Which future role feels best?",
        [
          "Business leader",
          "Accountant or finance analyst",
          "Marketing manager",
          "Economics specialist",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 3 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
      [
        "Which career area also interests you?",
        [
          "General business management",
          "Finance and banking",
          "Marketing and sales",
          "Economics and public policy",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 2, "Banking": 3 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
      [
        "Which strength do you value most?",
        [
          "Leadership and decision-making",
          "Accuracy with money and numbers",
          "Communication and persuasion",
          "Analytical understanding of the market",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 3, "Banking": 1 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
      [
        "Which long-term path seems most suitable?",
        [
          "BBA",
          "Accounting and Finance",
          "Marketing",
          "Economics",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 3 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
      [
        "Which kind of business challenge would you prefer?",
        [
          "Managing growth and teams",
          "Maintaining financial accuracy",
          "Increasing product reach",
          "Understanding economic patterns",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 3, "Banking": 1 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
      [
        "Which business output seems most exciting?",
        [
          "A successful company operation",
          "A well-managed financial system",
          "A powerful brand campaign",
          "A strong economic forecast",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 3, "Banking": 1 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
      [
        "Which field would you willingly study deeply?",
        [
          "Business management",
          "Finance and accounting",
          "Marketing strategy",
          "Economics and trends",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 3, "Banking": 1 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
      [
        "Which sector would you like to join in the future?",
        [
          "Business management",
          "Finance or banking",
          "Marketing and advertising",
          "Economic research",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 2, "Banking": 3 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
      [
        "Which option sounds closest to your future self?",
        [
          "Business executive",
          "Financial expert",
          "Marketing strategist",
          "Economic analyst",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 3, "Banking": 1 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
    ],
    personalityQuestions: [
      [
        "Which trait fits you best?",
        [
          "Leadership and initiative",
          "Accuracy and discipline",
          "Communication and influence",
          "Analysis and observation",
        ],
        {
          "0": { "BBA": 2 },
          "1": { "Accounting and Finance": 2, "Banking": 1 },
          "2": { "Marketing": 2 },
          "3": { "Economics": 2 },
        },
      ],
      [
        "Which work style suits you most?",
        [
          "Managing people and operations",
          "Working carefully with figures",
          "Promoting ideas and products",
          "Understanding trends and systems",
        ],
        {
          "0": { "BBA": 2 },
          "1": { "Accounting and Finance": 2, "Banking": 1 },
          "2": { "Marketing": 2 },
          "3": { "Economics": 2 },
        },
      ],
      [
        "What motivates you most?",
        [
          "Business growth",
          "Financial control",
          "Brand success and visibility",
          "Understanding market forces",
        ],
        {
          "0": { "BBA": 2 },
          "1": { "Accounting and Finance": 2, "Banking": 1 },
          "2": { "Marketing": 2 },
          "3": { "Economics": 2 },
        },
      ],
      [
        "Which long-term role sounds best?",
        [
          "Business leader",
          "Finance professional",
          "Marketing specialist",
          "Economist",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 3, "Banking": 1 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
      [
        "Which environment sounds most suitable?",
        [
          "Corporate management",
          "Finance and banking office",
          "Creative brand and sales environment",
          "Economic research and analysis",
        ],
        {
          "0": { "BBA": 2 },
          "1": { "Accounting and Finance": 2, "Banking": 2 },
          "2": { "Marketing": 2 },
          "3": { "Economics": 2 },
        },
      ],
      [
        "Which challenge would you enjoy more?",
        [
          "Managing a business team",
          "Balancing budgets and finances",
          "Convincing customers and markets",
          "Understanding economic change",
        ],
        {
          "0": { "BBA": 2 },
          "1": { "Accounting and Finance": 2, "Banking": 1 },
          "2": { "Marketing": 2 },
          "3": { "Economics": 2 },
        },
      ],
      [
        "What kind of impact sounds meaningful to you?",
        [
          "Helping a business succeed",
          "Improving financial health",
          "Growing market presence",
          "Understanding and improving economic systems",
        ],
        {
          "0": { "BBA": 2 },
          "1": { "Accounting and Finance": 2, "Banking": 1 },
          "2": { "Marketing": 2 },
          "3": { "Economics": 2 },
        },
      ],
      [
        "Which combination fits you best?",
        [
          "Leadership + planning",
          "Numbers + accuracy",
          "Communication + persuasion",
          "Analysis + interpretation",
        ],
        {
          "0": { "BBA": 2 },
          "1": { "Accounting and Finance": 2, "Banking": 1 },
          "2": { "Marketing": 2 },
          "3": { "Economics": 2 },
        },
      ],
      [
        "Which future sounds most fulfilling?",
        [
          "Leading a business",
          "Becoming a finance expert",
          "Becoming a marketing expert",
          "Becoming an economics expert",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 3, "Banking": 1 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
      [
        "Which path feels closest to your strengths?",
        [
          "BBA",
          "Accounting and Finance",
          "Marketing",
          "Economics",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 3 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 3 },
        },
      ],
      [
        "Which work identity fits you best?",
        [
          "Manager",
          "Financial analyst",
          "Marketing strategist",
          "Economic analyst",
        ],
        {
          "0": { "BBA": 2 },
          "1": { "Accounting and Finance": 2, "Banking": 1 },
          "2": { "Marketing": 2 },
          "3": { "Economics": 2 },
        },
      ],
      [
        "What would you prefer to improve?",
        [
          "Business performance",
          "Financial efficiency",
          "Customer engagement",
          "Economic understanding",
        ],
        {
          "0": { "BBA": 2 },
          "1": { "Accounting and Finance": 2, "Banking": 1 },
          "2": { "Marketing": 2 },
          "3": { "Economics": 2 },
        },
      ],
      [
        "Which kind of responsibility sounds right for you?",
        [
          "Managing people and decisions",
          "Managing accounts and funds",
          "Managing campaigns and communication",
          "Managing analysis and market understanding",
        ],
        {
          "0": { "BBA": 2 },
          "1": { "Accounting and Finance": 2, "Banking": 1 },
          "2": { "Marketing": 2 },
          "3": { "Economics": 2 },
        },
      ],
      [
        "Which field sounds more natural to your personality?",
        [
          "Business administration",
          "Finance and accounting",
          "Marketing",
          "Economics",
        ],
        {
          "0": { "BBA": 2 },
          "1": { "Accounting and Finance": 2, "Banking": 1 },
          "2": { "Marketing": 2 },
          "3": { "Economics": 2 },
        },
      ],
      [
        "Which career direction would you choose confidently?",
        [
          "BBA",
          "Accounting and Finance",
          "Marketing",
          "Economics / Banking",
        ],
        {
          "0": { "BBA": 3 },
          "1": { "Accounting and Finance": 3 },
          "2": { "Marketing": 3 },
          "3": { "Economics": 2, "Banking": 2 },
        },
      ],
    ],
  },

  "FA": {
    targets: ["Psychology", "English", "Media Studies", "International Relations", "Education"],
    fieldQuestions: [
      [
        "Which subject area interests you most?",
        [
          "Human behavior and emotions",
          "Language and literature",
          "Media and communication",
          "Politics and global affairs",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 3 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
      [
        "Which future role sounds best?",
        [
          "Psychologist or counselor",
          "Writer, lecturer, or language expert",
          "Media professional or presenter",
          "IR analyst or diplomat",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 3, "Education": 1 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
      [
        "What kind of work would you enjoy most?",
        [
          "Understanding people and helping them",
          "Reading, writing, and expression",
          "Public communication and content creation",
          "Understanding world issues and policy",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 3, "Education": 1 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
      [
        "Which skill do you want to use the most?",
        [
          "Empathy and listening",
          "Writing and language use",
          "Speaking and communication",
          "Analysis of global issues",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 3, "Education": 1 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
      [
        "Which environment fits you best?",
        [
          "Counseling or psychological support",
          "Teaching, language, or writing settings",
          "Media and broadcast environment",
          "Policy, international, or political environment",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 3, "Education": 2 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
      [
        "Which outcome would make you proud?",
        [
          "Helping someone emotionally or mentally",
          "Producing strong writing or teaching",
          "Creating impactful media content",
          "Understanding and discussing world affairs",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 3, "Education": 1 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
      [
        "Which academic path sounds best?",
        [
          "Psychology",
          "English",
          "Media Studies",
          "International Relations",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 3 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
      [
        "Which activity sounds most interesting?",
        [
          "Counseling and understanding people",
          "Reading and writing deeply",
          "Creating content and communicating publicly",
          "Studying politics and world relationships",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 3, "Education": 1 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
      [
        "Which type of impact do you want to make?",
        [
          "Improve people’s mental wellbeing",
          "Improve language and learning",
          "Influence through media",
          "Understand and discuss world affairs",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 2, "Education": 2 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
      [
        "Which option sounds most natural to you?",
        [
          "Helping others emotionally",
          "Expressing ideas in words",
          "Speaking to an audience",
          "Discussing political and international topics",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 3, "Education": 1 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
      [
        "Which future sounds most fulfilling?",
        [
          "Psychologist",
          "Writer / teacher / lecturer",
          "Media professional",
          "IR specialist",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 2, "Education": 2 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
      [
        "Which kind of content appeals most to you?",
        [
          "Human behavior and emotional growth",
          "Literature and language",
          "News, media, and storytelling",
          "Global politics and diplomacy",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 3 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
      [
        "Which skill area feels strongest?",
        [
          "Understanding people",
          "Writing and language",
          "Presentation and media communication",
          "Political and world analysis",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 3, "Education": 1 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
      [
        "Which long-term academic interest seems best?",
        [
          "Psychology",
          "English / Education",
          "Media Studies",
          "International Relations",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 2, "Education": 2 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
      [
        "Which field feels closest to your future self?",
        [
          "Psychology",
          "English or Education",
          "Media Studies",
          "International Relations",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 2, "Education": 2 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
    ],
    personalityQuestions: [
      [
        "Which trait fits you best?",
        [
          "Empathy and patience",
          "Love for language and expression",
          "Confidence in communication",
          "Curiosity about society and the world",
        ],
        {
          "0": { "Psychology": 2 },
          "1": { "English": 2, "Education": 1 },
          "2": { "Media Studies": 2 },
          "3": { "International Relations": 2 },
        },
      ],
      [
        "Which work style suits you most?",
        [
          "Helping and listening to people",
          "Reading, writing, and explaining",
          "Presenting and engaging with an audience",
          "Analyzing ideas and global issues",
        ],
        {
          "0": { "Psychology": 2 },
          "1": { "English": 2, "Education": 1 },
          "2": { "Media Studies": 2 },
          "3": { "International Relations": 2 },
        },
      ],
      [
        "What motivates you more?",
        [
          "Helping personal growth and wellbeing",
          "Strong communication and teaching",
          "Reaching people through media",
          "Understanding society and international affairs",
        ],
        {
          "0": { "Psychology": 2 },
          "1": { "English": 2, "Education": 1 },
          "2": { "Media Studies": 2 },
          "3": { "International Relations": 2 },
        },
      ],
      [
        "Which long-term role sounds best?",
        [
          "Psychologist",
          "Teacher / writer / lecturer",
          "Media communicator",
          "IR analyst / diplomat",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 2, "Education": 2 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
      [
        "What type of impact matters most to you?",
        [
          "Helping minds and emotions",
          "Improving learning and language",
          "Shaping ideas through media",
          "Understanding the world and policy",
        ],
        {
          "0": { "Psychology": 2 },
          "1": { "English": 2, "Education": 1 },
          "2": { "Media Studies": 2 },
          "3": { "International Relations": 2 },
        },
      ],
      [
        "Which environment fits your personality more?",
        [
          "Counseling / support spaces",
          "Schools / books / language spaces",
          "Media / public communication spaces",
          "Research / policy / diplomacy spaces",
        ],
        {
          "0": { "Psychology": 2 },
          "1": { "English": 2, "Education": 1 },
          "2": { "Media Studies": 2 },
          "3": { "International Relations": 2 },
        },
      ],
      [
        "Which statement sounds most like you?",
        [
          "I like understanding people deeply",
          "I like expressing ideas through words",
          "I like speaking and presenting ideas publicly",
          "I like understanding countries, politics, and society",
        ],
        {
          "0": { "Psychology": 2 },
          "1": { "English": 2, "Education": 1 },
          "2": { "Media Studies": 2 },
          "3": { "International Relations": 2 },
        },
      ],
      [
        "What kind of work would you repeat happily for years?",
        [
          "Helping people psychologically",
          "Teaching / writing / reading",
          "Media communication and content",
          "Global and political analysis",
        ],
        {
          "0": { "Psychology": 2 },
          "1": { "English": 2, "Education": 1 },
          "2": { "Media Studies": 2 },
          "3": { "International Relations": 2 },
        },
      ],
      [
        "Which academic direction feels closest to you?",
        [
          "Psychology",
          "English / Education",
          "Media Studies",
          "International Relations",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 2, "Education": 2 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
      [
        "Which type of contribution sounds best?",
        [
          "Supporting people emotionally",
          "Educating or writing effectively",
          "Communicating ideas to society",
          "Understanding global and political issues",
        ],
        {
          "0": { "Psychology": 2 },
          "1": { "English": 2, "Education": 1 },
          "2": { "Media Studies": 2 },
          "3": { "International Relations": 2 },
        },
      ],
      [
        "Which field sounds most natural to your mindset?",
        [
          "Psychology",
          "English / Education",
          "Media Studies",
          "International Relations",
        ],
        {
          "0": { "Psychology": 2 },
          "1": { "English": 2, "Education": 2 },
          "2": { "Media Studies": 2 },
          "3": { "International Relations": 2 },
        },
      ],
      [
        "Which kind of role identity suits you best?",
        [
          "Counselor / psychologist",
          "Teacher / writer",
          "Presenter / media professional",
          "Policy / IR thinker",
        ],
        {
          "0": { "Psychology": 2 },
          "1": { "English": 2, "Education": 2 },
          "2": { "Media Studies": 2 },
          "3": { "International Relations": 2 },
        },
      ],
      [
        "Which future would you choose with confidence?",
        [
          "Psychology",
          "English / Education",
          "Media Studies",
          "International Relations",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 2, "Education": 2 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
      [
        "What kind of skills do you most want to use?",
        [
          "Empathy and emotional understanding",
          "Language and teaching ability",
          "Media and communication ability",
          "Analytical understanding of global issues",
        ],
        {
          "0": { "Psychology": 2 },
          "1": { "English": 2, "Education": 1 },
          "2": { "Media Studies": 2 },
          "3": { "International Relations": 2 },
        },
      ],
      [
        "Which path feels closest to your strengths?",
        [
          "Psychology",
          "English / Education",
          "Media Studies",
          "International Relations",
        ],
        {
          "0": { "Psychology": 3 },
          "1": { "English": 2, "Education": 2 },
          "2": { "Media Studies": 3 },
          "3": { "International Relations": 3 },
        },
      ],
    ],
  },
};

function generateQuizByField(field = "General") {
  const normalized = normalizeField(field);
  const bank = quizBanks[normalized] || quizBanks["ICS"];

  const fieldQuestions = pickUniqueQuestions(bank.fieldQuestions, 15).map(
    (q, i) =>
      buildQuestion(
        `field_${i + 1}_${Date.now()}_${Math.floor(Math.random() * 100000)}`,
        q[0],
        q[1],
        q[2],
        "field"
      )
  );

  const personalityQuestions = pickUniqueQuestions(
    bank.personalityQuestions,
    15
  ).map((q, i) =>
    buildQuestion(
      `personality_${i + 1}_${Date.now()}_${Math.floor(Math.random() * 100000)}`,
      q[0],
      q[1],
      q[2],
      "personality"
    )
  );

  return shuffleArray([...fieldQuestions, ...personalityQuestions]);
}

/* -----------------------------------
   HEALTH
----------------------------------- */

app.get("/", (_req, res) => {
  res.json({ message: "SCN backend is running" });
});

/* -----------------------------------
   CHAT
----------------------------------- */

app.post("/chat", async (req, res) => {
  try {
    const { message, field, educationLevel, preferredLanguage } = req.body;
    const normalizedField = normalizeField(field || "General");

    const prompt = `
You are Smart Career Navigator AI, a student guidance assistant for Pakistan.

Student Context:
- Education level: ${educationLevel || "Unknown"}
- Current field/background: ${normalizedField}
- Preferred language hint: ${preferredLanguage || "Auto detect"}

Instructions:
- Reply in the same language as the user.
- If user writes in Roman Urdu, reply in Roman Urdu.
- If user writes in Urdu, reply in Urdu.
- If user writes in English, reply in English.
- Guide the student according to their actual background.
- Do not make the conversation only about engineering.
- If student is from Pre-Medical, discuss medical and health paths.
- If student is from ICS, discuss computing and technology paths.
- If student is from ICOM, discuss business and finance paths.
- If student is from FA, discuss humanities, education, media, psychology, and social sciences.
- If student is from Pre-Engineering, discuss engineering and related technical paths.
- Keep the answer practical, student-friendly, and specific.
- Avoid generic repeated replies.

User message:
${message}
`;

    const reply = await askGeminiText(prompt);

    res.json({ reply });
  } catch (err) {
    const status = err?.response?.status;
    const details = err?.response?.data || err.message || "Unknown error";

    if (status === 503 || status === 429) {
      return res.status(503).json({
        error: "Chat temporarily unavailable",
        details: "The AI model is busy or quota-limited right now. Please try again later.",
      });
    }

    res.status(500).json({
      error: "Chat failed",
      details,
    });
  }
});

/* -----------------------------------
   QUIZ
----------------------------------- */

app.post("/quiz", async (req, res) => {
  try {
    const { field, educationLevel } = req.body;

    // 1) Try AI dynamic quiz first
    try {
      const aiQuiz = await generateDynamicQuizWithAI(
        field || "General",
        educationLevel || "Unknown"
      );

      return res.json(aiQuiz);
    } catch (aiError) {
      console.error("AI dynamic quiz failed, using fallback:", aiError.message);
    }

    // 2) Fallback to local static bank
    const fallbackQuiz = generateQuizByField(field || "General");
    return res.json(fallbackQuiz);
  } catch (err) {
    return res.status(500).json({
      error: "Quiz generation failed",
      details: err?.message || "Unknown error",
    });
  }
});

/* -----------------------------------
   QUIZ RESULT
----------------------------------- */

app.post("/quiz-result", async (req, res) => {
  try {
    const { questions, answers } = req.body;

    if (!Array.isArray(questions) || typeof answers !== "object" || answers === null) {
      return res.status(400).json({
        error: "Invalid quiz payload",
      });
    }

    const scores = {};

    for (const question of questions) {
      const selectedIndex = answers[question.id];

      if (selectedIndex === undefined || selectedIndex === null) continue;

      const scoringMap = question.scoring?.[String(selectedIndex)];
      if (!scoringMap || typeof scoringMap !== "object") continue;

      for (const [field, value] of Object.entries(scoringMap)) {
        if (!scores[field]) scores[field] = 0;
        scores[field] += Number(value || 0);
      }
    }

    const rankedFields = Object.entries(scores)
      .map(([field, score]) => ({ field, score }))
      .sort((a, b) => b.score - a.score);

    res.json({
      recommendedField: rankedFields[0]?.field || "No Recommendation",
      rankedFields,
      scoreSummary: scores,
    });
  } catch (err) {
    res.status(500).json({
      error: "Quiz result failed",
      details: err?.message || "Unknown error",
    });
  }
});

/* -----------------------------------
   ROADMAP
----------------------------------- */

app.post("/roadmap", async (req, res) => {
  try {
    const { chosenPath, field, educationLevel } = req.body;

    const prompt = `
Create a simple and practical roadmap for a student in Pakistan.

Context:
- Chosen Path: ${chosenPath || "General Program"}
- Field: ${field || "General"}
- Education Level: ${educationLevel || "Unknown"}

Include:
- admission guidance
- important skills
- next steps
- future growth direction

Use English only.
Keep it step-by-step and easy to understand.
`;

    const roadmap = await askGeminiText(prompt);

    res.json({ roadmap });
  } catch (err) {
    const status = err?.response?.status;
    const details = err?.response?.data || err.message || "Unknown error";

    if (status === 503 || status === 429) {
      return res.status(503).json({
        error: "Roadmap temporarily unavailable",
        details: "The AI model is busy or quota-limited right now. Please try again later.",
      });
    }

    res.status(500).json({
      error: "Roadmap failed",
      details,
    });
  }
});

const PORT = process.env.PORT || port || 3000;

app.listen(PORT, () => {
  console.log(`SCN Backend running on port ${PORT}`);
});