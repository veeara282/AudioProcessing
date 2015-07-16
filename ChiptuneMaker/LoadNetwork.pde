File file = new File("data/neural-network.blob");

BasicNetwork load() {
  ObjectInputStream in = null;
  try {
    in = new ObjectInputStream(new FileInputStream(file));
    return (BasicNetwork) in.readObject();
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
  finally {
    in.close();
  }
}
