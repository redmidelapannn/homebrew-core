class Maclaunch < Formula
  desc "Command-line utility for managing your launch agents and daemons."
  homepage "https://github.com/HazCod/maclaunch"
  url "https://github.com/HazCod/maclaunch/archive/0.2.tar.gz"
  sha256 "f265e819751ed242abaa2d0ef8b1ed3ffed6df043992151e5f905cc19555a079"

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
