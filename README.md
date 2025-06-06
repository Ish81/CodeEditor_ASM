# 📝 Simple Text File Editor in Assembly (NASM)

This is a basic text file editor written in **x86-64 NASM Assembly** for Linux systems. It allows users to:

* **Enter a filename**
* **View existing content** if the file exists
* **Append new content** line by line
* **Create the file** if it does not already exist

---

## 🧠 How It Works

1. **Prompts user for a filename**
2. **Tries to open the file** in read-only mode:

   * If the file exists, it displays its contents.
   * If the file does not exist, it proceeds to create it.
3. **Opens the file** in append mode so new lines are added to the end.
4. **Takes user input** line-by-line (until `Ctrl+D` is pressed).
5. **Appends each line** into the file.
6. **Closes the file** and exits.

---

## 🛠️ System Calls Used

| Syscall | Description      | Value |
| ------: | ---------------- | ----- |
|  `read` | Read from input  | 0     |
| `write` | Write to output  | 1     |
|  `open` | Open a file      | 2     |
| `close` | Close a file     | 3     |
|  `exit` | Exit the program | 60    |

---

## 🗂️ File Structure

```asm
section .bss
    filename      resb 100      ; Buffer for file name
    buffer        resb 4096     ; For reading file contents
    input_line    resb 512      ; For editing/appending content

section .data
    msg_filename  db "Enter file name: ", 0
    msg_existing  db "Existing content:", 10, 0
    msg_text      db "Edit content (press Enter to save line, Ctrl+D to finish):", 10, 0
    newline       db 10, 0

section .text
    global _start
```

---

## 🧾 Features

* 📂 **View Existing File**: Displays current content before editing.
* ✍️ **Append New Content**: User can enter new lines to append.
* 🆕 **Create New File**: If the file doesn’t exist, it’s created.
* 🛑 **Graceful Exit**: Ends input on `Ctrl+D`.

---

## 🧪 How to Run

### 🧰 Requirements

* Linux OS
* NASM assembler
* `ld` linker

### 🔧 Build Instructions

```bash
nasm -f elf64 editor.asm -o editor.o
ld editor.o -o editor
```

### ▶️ Run the Program

```bash
./editor
```

---

## 📌 Example Usage

```
$ ./editor
Enter file name: notes.txt
Existing content:
Hello world!
Edit content (press Enter to save line, Ctrl+D to finish):
This is a new line.
Another line.
[Press Ctrl+D]
```

---

## ⚠️ Notes

* The input ends with `Ctrl+D` (EOF) which signals the program to stop editing.
* The file is opened with the flags: `O_WRONLY | O_APPEND | O_CREAT` (`0x441`), so previous content is preserved and new content is appended.
* This program does **not** support backspace/delete—what you type is what gets written.

---

## 🚀 Future Improvements

* Support backspace/delete
* Handle file permissions more gracefully
* Add line editing capabilities
* Support command-line filename as argument

---

## 🧑‍💻 Author

Made with low-level love in Assembly 💻
You can modify and extend this editor for learning and personal use.

---

Let me know if you'd like a commented version of the `.asm` file too!
