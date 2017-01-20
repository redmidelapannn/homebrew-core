class Maclaunch < Formula
  desc "Command-line utility for managing your launch agents and daemons."
  homepage "https://github.com/HazCod/maclaunch"
  url "https://github.com/HazCod/maclaunch/archive/0.2.tar.gz"
  sha256 "1a2c7f62cb5331df9804c481fecc41e29b4dff29"

  def install
    # for clarity, remove .sh
    mv "maclaunch.sh", "maclaunch"
    bin.install "maclaunch"
  end

  test do
    # just run the command to test the install
    system "#{bin}/maclaunch"
  end
end
