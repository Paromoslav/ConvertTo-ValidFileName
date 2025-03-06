# ConvertTo-ValidFileName

A PowerShell function that converts an input string into a valid file name by replacing forbidden characters with visually similar alternatives. It supports pipeline input, handles both plain file names and full paths, and includes options for trimming whitespace and extraneous backslashes.

## Overview

Windows file systems restrict certain characters in file names. This function addresses that by:

- Replacing control characters (ASCII 1–31) with alternative symbols.
- Substituting forbidden characters (e.g., `"`, `*`, `/`, `<`, `>`, `?`, `|`) with visually similar counterparts.
- Preserving file extensions when present.
- Optionally trimming unwanted whitespace and backslashes.
- Ensuring that each path component does not exceed 255 characters.

## Features

- **Pipeline Input**: Accepts input directly from the pipeline.
- **Flexible Parameter Aliases**: Supports multiple aliases for the input string (e.g., `Input`, `Text`, `LiteralPath`).
- **Customizable Behavior**: Use switches to trim the start of the string or remove trailing backslashes.
- **Path-Specific Handling**: Adjusts processing when the input is a full file path.
- **Length Enforcement**: Truncates overly long path components to meet file system restrictions.

## Installation

Copy the function code into your PowerShell script or module. You can also add it to your PowerShell profile for global availability.

## Usage

Once imported into your session, you can use the function in various ways:

### Example 1: Convert a Simple File Name

```powershell
$validName = ConvertTo-ValidFileName -String "Invalid:File*Name?.txt"
Write-Output $validName
```

### Example 2: Using Pipeline Input

```powershell
"Another:Invalid/File|Name.txt" | ConvertTo-ValidFileName
```

### Example 3: Processing a Full Path with Options

```powershell
$validPath = ConvertTo-ValidFileName -String "C:\Invalid\Path:Name\Example.txt" -IsPath -TrimBackslash
Write-Output $validPath
```

## Parameters

- **`-String`**  
  The input string to be converted. This parameter accepts multiple aliases such as `Input`, `Text`, `FileName`, `LiteralPath`, etc.

- **`-IsPath`**  
  Indicates that the input string is a full file path. Adjusts processing for drive letters and path separators accordingly.

- **`-TrimStart`**  
  Trims leading whitespace from the input string.

- **`-TrimBackslash`**  
  Removes trailing backslashes from the input string. Useful when working with directory paths.

## How It Works

1. **Initialization**  
   - The function creates a replacement dictionary that maps control characters (ASCII 1–31) to alternative symbols.
   - Sets up additional replacements for forbidden characters.

2. **Input Trimming and Validation**  
   - The function optionally trims whitespace and backslashes.  
   - It validates that the resulting string is not empty.

3. **File Name Parsing**  
   - Separates the file extension (if present) from the base name.  
   - Applies different logic when the input is a full path.

4. **Character Replacement**  
   - Each character in the combined base name and extension is replaced according to the replacement dictionary.  
   - Special handling is provided for trailing periods.

5. **Component Length Enforcement**  
   - If any part of the file path exceeds 255 characters, it is trimmed and padded to meet file system constraints.
