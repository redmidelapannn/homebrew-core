class Afsctool < Formula
  desc "Control HFS+ and APFS transparent file compression"
  homepage "https://github.com/RJVB/afsctool"
  url "https://github.com/RJVB/afsctool/archive/1.7.0.tar.gz"
  sha256 "4ae643ae43aca22e96cd6a2a471f5d975a3d08eafa937c1fc8e562691bcbfb1a"
  bottle do
    cellar :any_skip_relocation
    sha256 "6aa8a197c4798f31a2e43f34dd35ac9598836831017694bc954ebe3eb522eeb8" => :catalina
    sha256 "4dc0880d117ec9ca6d682f563deb2da864740347bd8e9258a26000739baa7e79" => :mojave
    sha256 "1219304f901de6f4942b3604abdcaf6ce3c6f6cfbba7ad5633553b4007f76535" => :high_sierra
  end
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "google-sparsehash"

  def install
    cd buildpath do
      mkpath "afsctool/build"
      cd "afsctool/build" do
        system "cmake", "-Wno-dev", "../.."
        system "make"
        bin.install "afsctool"
      end
    end
  end

  test do
    path = testpath / "foo"
    path.write "some text here."
    system "#{bin}/afsctool", "-c", path
    system "#{bin}/afsctool", "-v", path
  end
end
