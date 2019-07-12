class MarathonSwift < Formula
  desc "Makes it easy to write, run and manage your Swift scripts"
  homepage "https://github.com/JohnSundell/Marathon"
  url "https://github.com/JohnSundell/Marathon/archive/3.2.0.tar.gz"
  sha256 "be40fbed247105b2f9336b9c636c638aa830bd5f6500fba09fdb48a42c6d73c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "18424b2f110e192f4588e2192af8fbaa8fa2e2c59790d10c0be96e5aa0f4689d" => :mojave
    sha256 "21d9ea89ab5c5ff4fe587ab9f161a974b974750d80c7ab79406ca8c519540f88" => :high_sierra
  end

  depends_on :xcode => ["9.3", :build]

  def install
    # system "swift", "package", "--disable-sandbox", "update"
    system "swift", "build", "-c", "release", "--disable-sandbox"

    system "make", "install_bin", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/marathon", "create", "helloWorld",
           "import Foundation; print(\"Hello World\")", "--no-xcode",
           "--no-open"
    system "#{bin}/marathon", "run", "helloWorld"
  end
end
