////https://forum.processing.org/two/discussion/7105/how-to-create-zip-files-using-processing
////https://github.com/processing/processing/blob/349f413a3fb63a75e0b096097a5b0ba7f5565198/app/src/processing/app/tools/Archiver.java

//import java.io.File;
//import java.io.FileInputStream;
//import java.io.FileOutputStream;
//import java.io.IOException;
//import java.util.zip.ZipEntry;
//import java.util.zip.ZipOutputStream;

//String dir;

//void setup() {
//  try {
//    //Zipper x = new Zipper();
//    //x.start();
//    dir = sketchPath();
//    File sketchFolder = new File(dir + "/test/");
//    String dest=dir + "/res.zip";
//    File dfile= new File(dest);
//    FileOutputStream fos= new FileOutputStream(dfile);
//    ZipOutputStream zos= new ZipOutputStream(fos);
//    buildZip(sketchFolder, sketchFolder.getName(), zos);
//    zos.flush();
//    zos.close();
//  } 
//  catch (Exception e) {
//    println("Exception caught in Setup");
//    println(e);
//  }
//  exit();
//}

//void buildZip(File dir, String sofar, ZipOutputStream zos) throws IOException {
//  String files[] = dir.list();
//  for (int i = 0; i < files.length; i++) {
//    if (files[i].equals(".") || //$NON-NLS-1$
//        files[i].equals("..")) continue; //$NON-NLS-1$

//    File sub = new File(dir, files[i]);
//    String nowfar = (sofar == null) ?
//      files[i] : (sofar + "/" + files[i]); //$NON-NLS-1$

//    if (sub.isDirectory()) {
//      // directories are empty entries and have / at the end
//      ZipEntry entry = new ZipEntry(nowfar + "/"); //$NON-NLS-1$
//      //System.out.println(entry);
//      zos.putNextEntry(entry);
//      zos.closeEntry();
//      buildZip(sub, nowfar, zos);

//    } else {
//      ZipEntry entry = new ZipEntry(nowfar);
//      entry.setTime(sub.lastModified());
//      zos.putNextEntry(entry);
//      zos.write(loadBytesRaw(sub));
//      //int len;
//      //byte[] buf = new byte[1024];
//      //FileInputStream fis= new FileInputStream(sub);
//      //while ((len=fis.read(buf))>0) {
//      //  zos.write(buf, 0, len);
//      //}
//      //fis.close();
//      zos.closeEntry();
//    }
//  }
//}

///**
// * Same as PApplet.loadBytes(), however never does gzip decoding.
// */
//byte[] loadBytesRaw(File file) throws IOException {
//  int size = (int) file.length();
//  FileInputStream input = new FileInputStream(file);
//  byte buffer[] = new byte[size];
//  int offset = 0;
//  int bytesRead;
//  while ((bytesRead = input.read(buffer, offset, size-offset)) != -1) {
//    offset += bytesRead;
//    if (bytesRead == 0) break;
//  }
//  input.close();  // weren't properly being closed
//  input = null;
//  return buffer;
//}









////https://forum.processing.org/two/discussion/1056/how-to-extract-contents-of-a-zip-file-using-processing
////https://github.com/processing/processing/blob/f25160db77d31004e1321d51c279dcb808b6ae7b/build/macosx/appbundler/src/com/oracle/appbundler/AppBundlerTask.java
////https://github.com/processing/processing/blob/b9049243bd74c8a6395f102944f04ca5196ec43d/app/src/processing/app/Util.java

//import java.io.BufferedOutputStream;
//import java.io.BufferedInputStream;
//import java.io.FileInputStream;
//import java.io.FileOutputStream;
//import java.util.zip.ZipEntry;
//import java.util.zip.ZipInputStream;
//import java.util.zip.CheckedInputStream;
//import java.util.zip.Adler32;

//final int BUFFER_SIZE = 2048;
//String dir;

//void setup() {
//  try {
//    //Unzip x = new Unzip();
//    //x.start();
//    dir = sketchPath();
//    File contentsDirectory = new File(dir, "Contents");
//    contentsDirectory.mkdir();
//    copyResources(contentsDirectory);
//  } 
//  catch (Exception e) {
//    println("Exception caught in Setup");
//    println(e);
//  }
//  exit();
//}

//void copyResources(File resourcesDirectory) throws IOException {
//  // Unzip res.zip into resources directory
//  //InputStream inputStream = getClass().getResourceAsStream("res.zip");
//  FileInputStream fis = new FileInputStream(dir+"/res.zip");
//  ZipInputStream zipInputStream = new ZipInputStream(fis);

//  try {
//    ZipEntry zipEntry = zipInputStream.getNextEntry();
//    while (zipEntry != null) {
//      File file = new File(resourcesDirectory, zipEntry.getName());
//      println(zipEntry.getName());//we can get the file name and location

//      if (zipEntry.isDirectory()) {
//        file.mkdir();
//      } else {
//        OutputStream outputStream =
//          new BufferedOutputStream(new FileOutputStream(file), BUFFER_SIZE);
//        try {
//          int b = zipInputStream.read();
//          while (b != -1) {
//            outputStream.write(b);
//            b = zipInputStream.read();
//          }
//          outputStream.flush();
//        } finally {
//          outputStream.close();
//        }
//        file.setLastModified(zipEntry.getTime());
//      }
//      zipEntry = zipInputStream.getNextEntry();
//    }
//  } finally {
//    zipInputStream.close();
//  }
//}

//void copyResources(File outputDirectory, File inputFile) throws IOException {
//  // Unzip inputFile into outputDirectory
//  FileInputStream fis = new FileInputStream(inputFile);
//  ZipInputStream zipInputStream = new ZipInputStream(fis);

//  try {
//    ZipEntry zipEntry = zipInputStream.getNextEntry();
//    while (zipEntry != null) {
//      File file = new File(outputDirectory, zipEntry.getName());
//      println(zipEntry.getName());//we can get the file name and location

//      if (zipEntry.isDirectory()) {
//        file.mkdir();
//      } else {
//        OutputStream outputStream =
//          new BufferedOutputStream(new FileOutputStream(file), BUFFER_SIZE);
//        try {
//          int b = zipInputStream.read();
//          while (b != -1) {
//            outputStream.write(b);
//            b = zipInputStream.read();
//          }
//          outputStream.flush();
//        } finally {
//          outputStream.close();
//        }
//        file.setLastModified(zipEntry.getTime());
//      }
//      zipEntry = zipInputStream.getNextEntry();
//    }
//  } finally {
//    zipInputStream.close();
//  }
//}

//void copyFile(File sourceFile, File targetFile) throws IOException{
//  BufferedInputStream from = new BufferedInputStream(new FileInputStream(sourceFile));
//  BufferedOutputStream to = new BufferedOutputStream(new FileOutputStream(targetFile));
//  byte[] buffer = new byte[16 * 1024];
//  int bytesRead;
//  while((bytesRead = from.read(buffer)) != -1){
//    to.write(buffer, 0, bytesRead);
//  }
//  from.close();
//  from = null;

//  to.flush();
//  to.close();
//  to = null;

//  targetFile.setLastModified(sourceFile.lastModified());
//  targetFile.setExecutable(sourceFile.canExecute());
//}

//void copyDir(File sourceDir, File targetDir) throws IOException {
//  if (sourceDir.equals(targetDir)){
//    final String urDum = "source and target directories are identical";
//    throw new IllegalArgumentException(urDum);
//  }
//  targetDir.mkdirs();
//  String files[] = sourceDir.list();
//  for (int i = 0; i < files.length; i++){
//    // Ignore dot files (.DS_Store), dot folders (.svn) while copying
//    if (files[i].charAt(0) == '.') continue;
//    //if (files[i].equals(".") || files[i].equals("..")) continue;
//    File source = new File(sourceDir, files[i]);
//    File target = new File(targetDir, files[i]);
//    if (source.isDirectory()){
//      //target.mkdirs();
//      copyDir(source, target);
//      target.setLastModified(source.lastModified());
//    } else {
//      copyFile(source, target);
//    }
//  }
//}

///**
// * Recursively creates a list of all files within the specified folder,
// * and returns a list of their relative paths.
// * Ignores any files/folders prefixed with a dot.
// * @param relative true return relative paths instead of absolute paths
// */
//String[] listFiles(File folder, boolean relative){
//  return listFiles(folder, relative, null);
//}


//String[] listFiles(File folder, boolean relative, String extension){
//  if (extension != null){
//    if (!extension.startsWith(".")){
//      extension = "." + extension;
//    }
//  }

//  StringList list = new StringList();
//  listFilesImpl(folder, relative, extension, list);

//  if (relative){
//    String[] outgoing = new String[list.size()];
//    // remove the slash (or backslash) as well
//    int prefixLength = folder.getAbsolutePath().length() + 1;
//    for (int i = 0; i < outgoing.length; i++){
//      outgoing[i] = list.get(i).substring(prefixLength);
//    }
//    return outgoing;
//  }
//  return list.array();
//}


//void listFilesImpl(File folder, boolean relative, String extension, StringList list){
//  File[] items = folder.listFiles();
//  if (items != null){
//    for (File item : items){
//      String name = item.getName();
//      if (name.charAt(0) != '.'){
//        if (item.isDirectory()){
//          listFilesImpl(item, relative, extension, list);

//        } else {  // a file
//          if (extension == null || name.endsWith(extension)){
//            list.append(item.getAbsolutePath());
//          }
//        }
//      }
//    }
//  }
//}

//void unzip(File zipFile, File dest){
//  try {
//    FileInputStream fis = new FileInputStream(zipFile);
//    CheckedInputStream checksum = new CheckedInputStream(fis, new Adler32());
//    ZipInputStream zis = new ZipInputStream(new BufferedInputStream(checksum));
//    ZipEntry next = null;
//    while ((next = zis.getNextEntry()) != null){
//      File currentFile = new File(dest, next.getName());
//      if (next.isDirectory()){
//        currentFile.mkdirs();
//      } else {
//        File parentDir = currentFile.getParentFile();
//        // Sometimes the directory entries aren't already created
//        if (!parentDir.exists()) {
//          parentDir.mkdirs();
//        }
//        currentFile.createNewFile();
//        unzipEntry(zis, currentFile);
//      }
//    }
//  } catch (Exception e){
//    e.printStackTrace();
//  }
//}


//void unzipEntry(ZipInputStream zin, File f) throws IOException {
//  FileOutputStream out = new FileOutputStream(f);
//  byte[] b = new byte[512];
//  int len = 0;
//  while ((len = zin.read(b)) != -1){
//    out.write(b, 0, len);
//  }
//  out.flush();
//  out.close();
//}