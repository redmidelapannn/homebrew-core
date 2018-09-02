class Ldid < Formula
  desc "Lets you manipulate the signature block in a Mach-O binary"
  homepage "https://cydia.saurik.com/info/ldid/"
  url "https://git.saurik.com/ldid.git",
    :tag => "v1.2.1",
    :revision => "e4b7adc1e02c9f0e16cc9ae2841192b386f6d4ea"
  head "https://git.saurik.com/ldid.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "4da13449cc76cbe75279a03f30752927c17a52d6861bec30f1984b477a340846" => :mojave
    sha256 "02d23c83888d33a65727af0b98f20181ead2d30e3b30c3380785fa410b5c38ea" => :high_sierra
    sha256 "bbdc0c85c788311037ced1d5dd194c1d599523843632e623d6f3ead762da79b6" => :sierra
    sha256 "0f4b637138dddc099a455eaccd7d5c2374a394c2f67cea7d75fa9a997e864433" => :el_capitan
  end

  depends_on "openssl"

  def install
    inreplace "make.sh" do |s|
      s.gsub! %r{^.*/Applications/Xcode-5.1.1.app.*}, ""

      # Reported upstream 2 Sep 2018 (to saurik via email)
      s.gsub! "-mmacosx-version-min=10.4", "-mmacosx-version-min=#{MacOS.version}"
      s.gsub! "for arch in i386 x86_64; do", "for arch in x86_64; do" if MacOS.version >= :mojave
    end
    system "./make.sh"
    bin.install "ldid"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main(int argc, char **argv) { return 0; }
    EOS

    system ENV.cc, "test.c", "-o", "test"
    system bin/"ldid", "-S", "test"
  end
end
