class Grakn < Formula
  desc "The Database for AI"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/v0.12.1/grakn-dist-0.12.1.tar.gz"
  sha256 "3658138ccd74e51a0072a42f5e4fff43763506b02e581b572b05f50b1c63eb72"

  bottle do
    cellar :any_skip_relocation
    sha256 "55ea780f977fcc7fb14dd6790b838fc32b1c04c103e42992c90eb26711f59411" => :sierra
    sha256 "3c13ec24cd28a25af95b3b9fbe2066f9138183468c626ad8f3c30fe67c658672" => :el_capitan
    sha256 "3c13ec24cd28a25af95b3b9fbe2066f9138183468c626ad8f3c30fe67c658672" => :yosemite
  end

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :CASSANDRA_HOME => ENV["CASSANDRA_HOME"])
  end

  test do
    assert_match /stopped/i, shell_output("#{bin}/grakn.sh status")
  end
end
