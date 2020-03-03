class CreateDmg < Formula
  desc "Shell script to build fancy DMGs"
  homepage "https://github.com/andreyvit/create-dmg"
  url "https://github.com/andreyvit/create-dmg/archive/v1.0.0.7.tar.gz"
  sha256 "36527e3ac845200a575853a4d82a75c4f4b7a902562336f43e8f17e9a1268e86"

  bottle do
    cellar :any_skip_relocation
    sha256 "500d8ac4f98de7de88a3b42099e4a5375ef382ae43c216a83802a178669aa1d4" => :catalina
    sha256 "500d8ac4f98de7de88a3b42099e4a5375ef382ae43c216a83802a178669aa1d4" => :mojave
    sha256 "500d8ac4f98de7de88a3b42099e4a5375ef382ae43c216a83802a178669aa1d4" => :high_sierra
  end

  def install
    system "support/brew-me.sh"
    bin.install "create-dmg"
  end

  test do
    File.write(testpath/"Brew-Eula.txt", "Eula")
    (testpath/"Test-Source").mkpath
    (testpath/"Test-Source/Brew.app").mkpath
    system "#{bin}/create-dmg", "--sandbox-safe", "--eula", testpath/"Brew-Eula.txt", testpath/"Brew-Test.dmg", testpath/"Test-Source"
  end
end
