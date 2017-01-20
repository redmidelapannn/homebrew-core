class Maclaunch < Formula
  desc "Command-line utility for managing your launch agents and daemons."
  homepage "https://github.com/HazCod/maclaunch"
  url "https://github.com/HazCod/maclaunch/archive/0.1.tar.gz"
  sha256 "f7aee097e3871f72cb38e1f04bf0a586f8371f984a71e212cf210b56df2cebb2"

  def install
    mv "maclaunch.sh", "maclaunch"
    bin.install "maclaunch"
  end

  test do
    system "#{bin}/maclaunch"
  end
end
