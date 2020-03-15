class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      :tag      => "v1.12",
      :revision => "1f371947309c5ea6023b6d9065415697cbc75578"
  revision 2

  bottle do
    cellar :any
    sha256 "90b9c8441ca8d43f8b88ca9fb9502e5f17258c83363c6da51dbbbde517f306e1" => :catalina
    sha256 "0e53bfc92614b2604c2c93cfadeebf04091fb346fd566862d5751ca85470ab58" => :mojave
    sha256 "47cfe4b85946a50c65fd1eb17174b0fe256ce7b0a69caf42587055219bd4b370" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi" # Requires libffi v3 closure API; macOS version is too old
  depends_on "python@3.8" # Requires python3 executable

  def install
    # Build mpy-cross before building the rest of micropython. Build process expects executable at
    # path buildpath/"mpy-cross/mpy-cross", so build it and leave it here for now, install later.
    cd "mpy-cross" do
      system "make"
    end

    cd "ports/unix" do
      system "make", "axtls"
      system "make", "install", "PREFIX=#{prefix}"
    end

    bin.install "mpy-cross/mpy-cross"
  end

  test do
    # Test the FFI module
    (testpath/"ffi-hello.py").write <<~EOS
      import ffi

      libc = ffi.open("libc.dylib")
      printf = libc.func("v", "printf", "s")
      printf("Hello!\\n")
    EOS

    system bin/"mpy-cross", "ffi-hello.py"
    system bin/"micropython", "ffi-hello.py"
  end
end
