const fs = require("fs");
const path = require("path");

const rootDir = process.cwd();

const yearRegex = /^\d{4}$/;

const semesterIds = ["0", "1"];

const indexData = [];

const rootContents = fs.readdirSync(rootDir);

const yearDirs = rootContents
    .filter((item) => yearRegex.test(item))
    .filter((item) => {
        const itemPath = path.join(rootDir, item);
        return fs.statSync(itemPath).isDirectory();
    });

yearDirs.sort();

yearDirs.forEach((yearDir) => {
    const year = parseInt(yearDir, 10);
    const yearPath = path.join(rootDir, yearDir);

    const availableSemesters = [];

    semesterIds.forEach((semesterId) => {
        const dataJsonPath = path.join(yearPath, semesterId, "data.json");

        if (fs.existsSync(dataJsonPath)) {
            availableSemesters.push(semesterId);
        }
    });

    if (availableSemesters.length > 0) {
        indexData.push({
            year,
            semester: availableSemesters,
        });
    }
});

indexData.reverse();

fs.writeFileSync("index.json", JSON.stringify(indexData, null, 2));
console.log("Generated index.json:", JSON.stringify(indexData, null, 2));
