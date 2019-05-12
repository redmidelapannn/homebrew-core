class Zsxd < Formula
  desc "Zelda Mystery of Solarus XD"
  homepage "https://www.solarus-games.org/en/games/the-legend-of-zelda-mystery-of-solarus-xd"
  url "https://github.com/christopho/zsxd/archive/zsxd-1.11.0.tar.gz"
  sha256 "4c6e744ecc5b7e123f5e085ed993e8234cbef8046d2717d16121a2b711e0ccde"
  head "https://github.com/christopho/zsxd.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7069b0674f0445472f00abd0d0e6b81cdbd46a4ba5497045b34c33fd4f344e91" => :mojave
    sha256 "425d9217a79aad7d97db041dcba235484f08a7293f6c2c48b63689a62b02742c" => :high_sierra
    sha256 "b5571a6c91a24acddca0f4702589df0392e925cb3791feea05d2ef45dd6e0d9f" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "solarus"

  def install
    system "cmake", ".", *std_cmake_args, "-DSOLARUS_INSTALL_DATADIR=#{share}"
    system "make", "install"
  end

  test do
    system Formula["solarus"].bin/"solarus-run", "-help"
    system "/usr/bin/unzip", pkgshare/"data.solarus"
  end
end
