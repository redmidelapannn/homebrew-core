class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "https://beast.community/"
  url "https://github.com/beast-dev/beast-mcmc/archive/v1.10.4.tar.gz"
  sha256 "6e28e2df680364867e088acd181877a5d6a1d664f70abc6eccc2ce3a34f3c54a"
  head "https://github.com/beast-dev/beast-mcmc.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4171ab7d14bd2f5d092e16ab66552192b9491608e79e611e4024fd21c277202d" => :catalina
    sha256 "7fd868c0aac2ff52c3918771ee4f7c1058a33b39f3526d34abc57ad4cec0ba78" => :mojave
    sha256 "f8dc063a3884f2c39e138975a44be4a30097a11c5f35a10554b7b990f1cd464d" => :high_sierra
  end

  depends_on "ant" => :build
  depends_on "beagle"
  depends_on :java => "1.8"

  def install
    system "ant", "linux"
    libexec.install Dir["release/Linux/BEASTv*/*"]
    pkgshare.install_symlink libexec/"examples"
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    cp pkgshare/"examples/TestXML/ClockModels/testUCRelaxedClockLogNormal.xml", testpath

    # Run fewer generations to speed up tests
    inreplace "testUCRelaxedClockLogNormal.xml", 'chainLength="10000000"',
                                                 'chainLength="100000"'

    system "#{bin}/beast", "testUCRelaxedClockLogNormal.xml"

    %w[ops log trees].each do |ext|
      output = "testUCRelaxedClockLogNormal." + ext
      assert_predicate testpath/output, :exist?, "Failed to create #{output}"
    end
  end
end
