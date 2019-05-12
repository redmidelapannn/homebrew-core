class ZeldaRothSe < Formula
  desc "Zelda Return of the Hylian SE"
  homepage "https://www.solarus-games.org/en/games/the-legend-of-zelda-return-of-the-hylian-se"
  head "https://github.com/christopho/zelda_roth_se.git"

  stable do
    url "https://github.com/christopho/zelda_roth_se/archive/v1.1.0.tar.gz"
    sha256 "95baf3ce96372b1ce78d9af8ee9723840474ac8fc51e87eb54cc35777d68f5a8"

    # Support SOLARUS_INSTALL_DATADIR variable for CMake
    patch do
      url "https://github.com/christopho/zelda_roth_se/commit/e9b5bd907f5b50b17d65ebe2fa50760d322c537c.diff?full_index=1"
      sha256 "061b93efdd16c450f7c3483e690099d96280250b159336439ab0da0ad5c2e13d"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3c32a1b07bb6de4bac669d91d0077c0ab95f0e0d710e5eb1f47970ed005d1ec9" => :mojave
    sha256 "2bfe5c59bc1e0226822fc63f59e0f54558426e7a3399ce1fd394524da8bda330" => :high_sierra
    sha256 "783a8e72d2498f371433cc66cbb0638febe6aa6d6bc4c2c8cf3de65340dc9250" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "solarus"

  def install
    system "cmake", ".", *std_cmake_args, "-DSOLARUS_INSTALL_DATADIR=#{share}"
    system "make", "install"
  end

  test do
    system Formula["solarus"].bin/"solarus-run", "-help"
    system "/usr/bin/unzip", share/"zelda_roth_se/data.solarus"
  end
end
