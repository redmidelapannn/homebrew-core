class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.41.0.tar.gz"
  sha256 "e9209b57eab6c944e9831c98dde11335c901e17c79196ea09d88b85b9047d9ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e6e95a939e32652a854cd785eac72348a1b8e53c2c64d9c2d95a1d6271ac8cb" => :catalina
    sha256 "f90541ad8e36580ed1cf38a2b7e4f40ff1b84844768a2d4fea08e05a256dfcd9" => :mojave
    sha256 "571caf5e1be71473b78da88e7d39040b4e5fab77d691fa9f980679175d857f7d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    # Install bitrise
    bitrise_go_path = buildpath/"src/github.com/bitrise-io/bitrise"
    bitrise_go_path.install Dir["*"]

    cd bitrise_go_path do
      prefix.install_metafiles

      system "go", "build", "-o", bin/"bitrise"
    end
  end

  test do
    (testpath/"bitrise.yml").write <<~EOS
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    system "#{bin}/bitrise", "setup"
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
