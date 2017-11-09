class MarathonSwift < Formula
  desc "Makes it easy to write, run and manage your Swift scripts"
  homepage "https://github.com/JohnSundell/Marathon"
  url "https://github.com/JohnSundell/Marathon/archive/2.0.0.tar.gz"
  sha256 "51ca9bc5c67781ecdccb81bfdb4d424c0271cba7c19d4b7b06fda6a23b8a7d08"

  bottle do
    cellar :any_skip_relocation
    sha256 "76f3fbfa122c22d8cd788e79400e579e3b4649b21ab473f3ca202cc2b4bb1aea" => :high_sierra
    sha256 "78998fb2edb68110e2da43a16f6bedada85758536e8317d5095890447eef98f2" => :sierra
  end

  depends_on :xcode => ["8.3", :build]

  def install
    if MacOS::Xcode.version >= "9.0"
      system "swift", "package", "--disable-sandbox", "update"
      system "swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib",
             "--disable-sandbox"
    else
      ENV.delete("CC") # https://bugs.swift.org/browse/SR-3151
      system "swift", "package", "update"
      system "swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib"
    end

    system "make", "install_bin", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/marathon", "create", "helloWorld",
           "import Foundation; print(\"Hello World\")", "--no-xcode",
           "--no-open"
    system "#{bin}/marathon", "run", "helloWorld"
  end
end
