/*
helper functions and global variables
*/

byte[] magicToArray(){
  byte[] tmpMagic = new byte[_magicText.length()];
  for(int i = 0; i < _magicText.length(); i++){
    tmpMagic[i] = byte(_magicText.charAt(i));
  }
  return tmpMagic;
}

void copyResources(File outputDirectory, File inputFile) throws IOException {
  // Unzip inputFile into outputDirectory
  FileInputStream fis = new FileInputStream(inputFile);
  ZipInputStream zipInputStream = new ZipInputStream(fis);

  try {
    ZipEntry zipEntry = zipInputStream.getNextEntry();
    while (zipEntry != null) {
      File file = new File(outputDirectory, zipEntry.getName());
      println(zipEntry.getName());//we can get the file name and location

      if (zipEntry.isDirectory()) {
        file.mkdir();
      } else {
        OutputStream outputStream =
          new BufferedOutputStream(new FileOutputStream(file), BUFFER_SIZE);
        try {
          int b = zipInputStream.read();
          while (b != -1) {
            outputStream.write(b);
            b = zipInputStream.read();
          }
          outputStream.flush();
        } finally {
          outputStream.close();
        }
        file.setLastModified(zipEntry.getTime());
      }
      zipEntry = zipInputStream.getNextEntry();
    }
  } finally {
    zipInputStream.close();
  }
}