class Buildapp < Formula
  desc "Creates executables with SBCL"
  homepage "https://www.xach.com/lisp/buildapp/"
  url "https://github.com/xach/buildapp/archive/release-1.5.6.tar.gz"
  sha256 "d77fb6c151605da660b909af058206f7fe7d9faf972e2c30876d42cb03d6a3ed"
  revision 1
  head "https://github.com/xach/buildapp.git"

  bottle do
    rebuild 1
    sha256 "7e179a81db9bfcc85b20b310e1587c04d21179b0643045ea7f198661ca5dead8" => :high_sierra
    sha256 "af5b56e6a8c82c8880510f6383435d7cc545ef168292183abe9da9ee1e6f1889" => :sierra
    sha256 "191183a944537ffeb67fd7d2297e3dcfd1825ac3f1af4db629512f4bb8e9465f" => :el_capitan
  end

  depends_on "sbcl"

  def install
    bin.mkpath
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    code = "(defun f (a) (declare (ignore a)) (write-line \"Hello, homebrew\"))"
    system "#{bin}/buildapp", "--eval", code,
                              "--entry", "f",
                              "--output", "t"
    assert_equal `./t`, "Hello, homebrew\n"
  end
end
