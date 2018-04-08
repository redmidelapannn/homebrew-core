class Bubbros < Formula
  desc "The Bub's Brothers: Clone of the famous Bubble Bobble game"
  homepage "https://bub-n-bros.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bub-n-bros/bub-n-bros/1.6.2/bubbros-1.6.2.tar.gz"
  sha256 "0ad8a359c4632071a9c85c2684bae32aa0fa278632c49f092dc4078cfb9858c4"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f51e500eb6fd548817f689271ff0586af9df859a9f9af2d62d543fb7724e3516" => :high_sierra
    sha256 "7b1c1e2e97c8b351d2e6b73341bc222221650a020b7def27267fc2d7fe2f1b17" => :sierra
    sha256 "e7b032460372f9b9a24a39706511cf2a0fc0827f08319041a673a19d3ed664d4" => :el_capitan
  end

  depends_on "python@2"
  depends_on :x11 => :optional

  # Patches from debian https://sources.debian.net/patches/bubbros
  patch do
    url "https://sources.debian.net/data/main/b/bubbros/1.6.2-1/debian/patches/replace_sf_logo.patch"
    sha256 "f984c69efeb1b5052ef7756800e0e386fc3dfac03da49d600db8a463e222d37f"
  end

  patch do
    url "https://sources.debian.net/data/main/b/bubbros/1.6.2-1/debian/patches/config_in_homedir.patch"
    sha256 "2474b4438fb854a29552d5ddefd17a04f478756ea0135b4298b013d9093a228f"
  end

  patch do
    url "https://sources.debian.net/data/main/b/bubbros/1.6.2-1/debian/patches/disable_runtime_image_building.patch"
    sha256 "e96f5233442a54a342409abe8280f2a735d447e9f53b36463dfc0fcfaef53ccb"
  end

  patch do
    url "https://sources.debian.net/data/main/b/bubbros/1.6.2-1/debian/patches/manpages.patch"
    sha256 "ad0bd9b7f822e416d07af53d6720f1bc0ce4775593dd7bd84f3cdba294532f50"
  end

  patch do
    url "https://sources.debian.net/data/main/b/bubbros/1.6.2-1/debian/patches/remove_shabangs.patch"
    sha256 "99ab1326b4b5267fb6c7bdb85b84e184126aa21099bffbedd36adb26b11933db"
  end

  def install
    system "make", "-C", "bubbob"
    system "make", "-C", "display" if build.with? :x11
    system "python", "bubbob/images/buildcolors.py"

    man6.install "doc/BubBob.py.1" => "bubbros.6"
    man6.install "doc/Client.py.1" => "bubbros-client.6"
    man6.install "doc/bb.py.1" => "bubbros-server.6"

    prefix.install Dir["*"]

    bin.mkpath
    (bin/"bubbros").write shim_script("BubBob.py")
    (bin/"bubbros-client").write shim_script("display/Client.py")
    (bin/"bubbros-server").write shim_script("bubbob/bb.py")
  end

  def shim_script(target); <<~EOS
    #!/bin/bash
    cd "#{prefix}"
    python "#{target}" "$@"
    EOS
  end

  def caveats
    s = <<~EOS
      The Shared Memory extension of X11 display driver is not supported.
      Run the display client with --shm=no
        bubbros-client --shm=no
    EOS
    s if build.with? :x11
  end

  test do
    system "#{bin}/bubbros-client --help; test $? -eq 2"
    system "#{bin}/bubbros-server --help; test $? -eq 1"
  end
end
