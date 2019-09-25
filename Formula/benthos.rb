class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v2.14.0.tar.gz"
  sha256 "6545c8a49dfcc03156feb385a5e61881c4747d48a3da3711242d0ac819cb3d99"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a0a811180698b4a95f22d30a6507d545dbea98a1760c1bf7f5f91141577e3bf2" => :mojave
    sha256 "dd44c58a38280feb874d7d2c5209ec027f48bd159f651e2a225ea757212e0b65" => :high_sierra
    sha256 "a4e9e83a9829c1814be655369fbbb913fb7136e484147c52ca41963827cbf530" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/Jeffail/benthos"
    src.install buildpath.children
    src.cd do
      system "make", "VERSION=#{version}"
      bin.install "target/bin/benthos"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~EOS
      ---
      logger:
        level: ERROR
      input:
        type: file
        file:
          path: ./sample.txt
      pipeline:
        threads: 1
        processors:
         - type: decode
           decode:
           scheme: base64
      output:
        type: stdout
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
