class Libkeccak < Formula
  desc "Keccak-family hashing library"
  homepage "https://github.com/maandree/libkeccak"
  url "https://github.com/maandree/libkeccak/archive/1.1.4.tar.gz"
  sha256 "40e27983ea63faf47071402b212da48101b1dae37ce2702da947361ee8d4a313"

  bottle do
    cellar :any
    sha256 "de79f9f60527c3e365edac5b4f5c37639b0fae0eba27001f87527e1fb06cb1ab" => :mojave
    sha256 "9b828ba76ff15a9680fe851e848fab65ba922cbd91c82786de444e424fe4b7b8" => :high_sierra
    sha256 "0e09f480fe9e08102548f479af67ef0ba13df2fda8924c2920f00afd5ce1fce6" => :sierra
  end

  depends_on "binutils" => :build
  depends_on "coreutils" => :build
  depends_on "make" => :build

  def install
    system "make", "LIBEXT=dylib", "LIBFLAGS=-dynamiclib"
    system "make", "install", "LIBEXT=dylib", "LIBFLAGS=-dynamiclib", "PREFIX=#{prefix}"
    fix_libkeccak_symlinks
  end

  def fix_libkeccak_symlinks
    mv "#{lib}/libkeccak.dylib.1.1", "#{lib}/libkeccak.1.1.dylib"
    ln_s "#{lib}/libkeccak.1.1.dylib", "#{lib}/libkeccak.1.dylib"
    rm "#{lib}/libkeccak.dylib"
    ln_s "#{lib}/libkeccak.1.1.dylib", "#{lib}/libkeccak.dylib"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libkeccak.h>
      int main() {
      libkeccak_spec_t spec;
        libkeccak_state_t state;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
