class Picosat < Formula
  desc "SAT solver"
  homepage "http://fmv.jku.at/picosat/"
  url "https://github.com/jordi-petit/picosat/archive/965.tar.gz"
  sha256 "54a7189fab3f7afbb79f080018aa3d9f46975a52c5f92c80cf048ee5dab38a79"

  bottle do
    cellar :any_skip_relocation
    sha256 "12ca3b9d9582b981ae406a3ab36fa5d2ab57d192f2a09aa2633769c5381e8380" => :catalina
    sha256 "0c980c9ccad66821c7ee7feaaad3b31d3cdf4b85c563fede3bbe37ccad5d4cb0" => :mojave
    sha256 "2b61dab0df6abe3d210b018e5677114e8a98ba525d93c1c93ef8c65691e2df52" => :high_sierra
  end

  def install
    system "./configure.sh"
    system "make"
    bin.install "picosat"
    include.install "picosat.h"
    lib.install "libpicosat.a"
  end

  test do
  end
end
