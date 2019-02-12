class Drafter < Formula
  desc "Native C/C++ API Blueprint Parser"
  homepage "https://apiblueprint.org/"
  url "https://github.com/apiaryio/drafter/releases/download/v3.2.7/drafter-v3.2.7.tar.gz"
  sha256 "a2b7061e2524804f153ac2e80f6367ae65dfcd367f4ee406eddecc6303f7f7ef"
  head "https://github.com/apiaryio/drafter.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f7f5493c6e45824b5a50215faac551dcca98fd74c2b5f2121d64fc9db1189d89" => :mojave
    sha256 "b7cb5c87e309c3ea3e4a8c131b2a6b8712b1449d885973f352f827a83814b6d2" => :high_sierra
    sha256 "531fd4b0df0f15cddc264fab879230e6e6c87e59a2a914ec60e795efdd1695c6" => :sierra
  end

  depends_on "cmake" => :build

  def install
    if build.head?
      system "cmake", ".", *std_cmake_args
      system "make"
      system "make", "install"
    else
      system "./configure"
      system "make", "install", "DESTDIR=#{prefix}"
    end
  end

  test do
    (testpath/"api.apib").write <<~EOS
      # Homebrew API [/brew]

      ## Retrieve All Formula [GET /Formula]
      + Response 200 (application/json)
        + Attributes (array)
    EOS
    assert_equal "OK.", shell_output("#{bin}/drafter -l api.apib 2>&1").strip
  end
end
