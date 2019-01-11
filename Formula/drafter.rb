class Drafter < Formula
  desc "Native C/C++ API Blueprint Parser"
  homepage "https://apiblueprint.org/"
  url "https://github.com/apiaryio/drafter/releases/download/v3.2.7/drafter-v3.2.7.tar.gz"
  sha256 "a2b7061e2524804f153ac2e80f6367ae65dfcd367f4ee406eddecc6303f7f7ef"
  head "https://github.com/apiaryio/drafter.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "71589c5cf59d31814e220b5b13e71a7b7436a138534fbd815a0616e2f6c56a0c" => :mojave
    sha256 "b34ea9f53e92ceb277922ec95bc440500e372408e897916a809930ae654e665f" => :high_sierra
    sha256 "435f0bd86b01ba145c323897b198279ce34276c24a22e208effdcb7686c28f58" => :sierra
  end

  depends_on "cmake" => :build

  def install
    if build.head?
      system "cmake", ".", *std_cmake_args
      system "make"
    else
      system "./configure"
    end
    system "make", "install", "DESTDIR=#{prefix}"
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
