class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "http://beast.community/"
  url "https://github.com/beast-dev/beast-mcmc/archive/v1.8.4.tar.gz"
  sha256 "de8e7dd82eb9017b3028f3b06fd588e5ace57c2b7466ba2e585f9bd8381407af"
  head "https://github.com/beast-dev/beast-mcmc.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5cc0bde13c8a0f552e98ab531272a6069db40695049cbc25a8506060bcf4aa1b" => :high_sierra
    sha256 "8c32042a75b4f6e2ca28947a1b4f86792f7a23a4a31be99250d3501d7c0298ba" => :sierra
    sha256 "8be6c1688b04f9da0512d3f2273b54160dfecd787fd23c97efe2cdb41e9bc9e1" => :el_capitan
  end

  depends_on "ant" => :build
  depends_on :java => "1.7+"

  def install
    system "ant", "linux"
    libexec.install Dir["release/Linux/BEASTv*/*"]
    pkgshare.install_symlink libexec/"examples"
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    cp pkgshare/"examples/clockModels/testUCRelaxedClockLogNormal.xml", testpath

    # Run fewer generations to speed up tests
    inreplace "testUCRelaxedClockLogNormal.xml", 'chainLength="10000000"',
                                                 'chainLength="100000"'

    system "#{bin}/beast", "-beagle_off", "testUCRelaxedClockLogNormal.xml"

    %w[ops log trees].each do |ext|
      output = "testUCRelaxedClockLogNormal." + ext
      assert_predicate testpath/output, :exist?, "Failed to create #{output}"
    end
  end
end
