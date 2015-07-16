BasicNetwork load() {
  try {
    ObjectInputStream in = new ObjectInputStream(new FileInputStream(file));
    BasicNetwork yolo = (BasicNetwork) in.readObject();
    in.close();
    return yolo;
  }
  catch (ClassNotFoundException e) {
    System.err.println("Looks like Encog isn't imported properly :(");
    System.exit(1);
    return null;
  }
  catch (IOException e) {
    e.printStackTrace();
    return null;
  }
}

