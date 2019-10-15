class CreateDmg < Formula
  desc "Shell script to build fancy DMGs"
  homepage "https://github.com/andreyvit/create-dmg"
  url "https://t.keka.io/create-dmg.1.0.0.6.zip"
  sha256 "69cfef9a821fa395ce25a5f25a4bb0ebc83b1858c101ff387f165f9d9373f86a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f79816fe786969d0c2bbf6c025d1616b04add290a20def2492f73295b36bc76c" => :mojave
    sha256 "d99f697bf1d22dba54a87890b30f383bf4aec7ca5b54f180646041f9d046c243" => :high_sierra
    sha256 "d99f697bf1d22dba54a87890b30f383bf4aec7ca5b54f180646041f9d046c243" => :sierra
  end

  def install
    system "support/brew-me.sh"
    bin.install "create-dmg"
  end

  test do
    File.write(testpath/"Brew-Eula.txt", "Eula")
    (testpath/"Test-Source").mkpath
    (testpath/"Test-Source/Brew.app").mkpath
    system "#{bin}/create-dmg", "--sandbox-safe", "--skip-jenkins", "--eula", testpath/"Brew-Eula.txt", testpath/"Brew-Test.dmg", testpath/"Test-Source"
  end
end
