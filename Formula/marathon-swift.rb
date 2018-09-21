class MarathonSwift < Formula
  desc "Makes it easy to write, run and manage your Swift scripts"
  homepage "https://github.com/JohnSundell/Marathon"
  url "https://github.com/JohnSundell/Marathon/archive/3.1.0.tar.gz"
  sha256 "98f454bd788d8e6dc670c99f1fbafdfd1dd0cb75b09a5db3d407e5ef31265120"

  bottle do
    cellar :any_skip_relocation
    sha256 "3496319d63d131ff0df95ce739b3240b471b449a11f87cd7a86d9f9bbc164a3d" => :mojave
    sha256 "182168c8ac4425422146e5bd7344a6b22ad3b44264d76f8dfc2b81271ad8bdd8" => :high_sierra
  end

  depends_on :xcode => ["9.0", :build]

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
