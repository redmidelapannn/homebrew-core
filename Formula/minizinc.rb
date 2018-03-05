class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.1.7.tar.gz"
  sha256 "e59075bbdcc36821d757b3b3fff288f341a0d30ce63dc253cc26ade55292657d"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "85976b15eaad1cca996f469bdec8dc3f30c880b6bc8440b15f4dce90d2213f4e" => :high_sierra
    sha256 "892ee66f2a3bfc01476b619f1db876b20b2cc74d942ec8df6afc0ae41fc83be2" => :sierra
    sha256 "ac4b3280ac40c4edcbb77cb62842804c5a74ee04360c5aa3a87e84d1fd93404c" => :el_capitan
  end

  depends_on :arch => :x86_64
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    system bin/"mzn2doc", share/"examples/functions/warehouses.mzn"
  end
end
