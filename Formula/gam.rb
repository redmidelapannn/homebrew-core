class Gam < Formula
  desc "Command-line management for Google G Suite"
  homepage "https://github.com/jay0lee/GAM/wiki"
  url "https://github.com/jay0lee/GAM/archive/v4.30.tar.gz"
  sha256 "846b2902fe36019a9f4ebd4a911e780e103fb2d210971b8a4e407ddb6d8db4f6"
  head "https://github.com/jay0lee/GAM.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5a2ada2a04737a700bd2d6a267ff5efd0c79896aaf27c071a5482efba22694b" => :sierra
    sha256 "c5a2ada2a04737a700bd2d6a267ff5efd0c79896aaf27c071a5482efba22694b" => :el_capitan
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"src/gam.py" => "gam"
  end

  test do
    system "#{bin}/gam | grep 'GAM 4.30'"
  end
end
