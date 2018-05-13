class MarathonSwift < Formula
  desc "Makes it easy to write, run and manage your Swift scripts"
  homepage "https://github.com/JohnSundell/Marathon"
  url "https://github.com/JohnSundell/Marathon/archive/3.0.0.tar.gz"
  sha256 "5dd1f495a8d69d9c3450735b771f816a838a040a45c682b0c42ac17105058a6e"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec7d84b17ded694124ec3f790ba7a8c8e2755ce01d1016e9c0e7aa9ad02c3f1d" => :high_sierra
  end

  depends_on :xcode => ["9.3", :build]

  def install
    system "swift", "package", "--disable-sandbox", "update"
    system "swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib",
           "--disable-sandbox"
    system "make", "install_bin", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/marathon", "create", "helloWorld",
           "import Foundation; print(\"Hello World\")", "--no-xcode",
           "--no-open"
    system "#{bin}/marathon", "run", "helloWorld"
  end
end
