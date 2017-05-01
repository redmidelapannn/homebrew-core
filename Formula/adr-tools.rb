class AdrTools < Formula
  desc "CLI tool for working with Architecture Decision Records."
  homepage "https://github.com/npryce/adr-tools"
  url "https://github.com/npryce/adr-tools/archive/2.1.0.tar.gz"
  sha256 "1ef028cfeaa1b262a5c62845aa8965be169705370983f9ff73b17ec77bf75f70"

  bottle do
    cellar :any_skip_relocation
    sha256 "f374485960a827b341752734ce4d9aeb87cc55577a22fc428929ad6a6384c906" => :sierra
    sha256 "f79eb34b1788c9e298615c72693638f47dc4585a6384563664e37dff1dc02350" => :el_capitan
    sha256 "f79eb34b1788c9e298615c72693638f47dc4585a6384563664e37dff1dc02350" => :yosemite
  end

  def install
    config = buildpath/"src/adr-config"

    # Unlink and re-write to matches homebrew's installation conventions
    config.unlink
    config.write <<-EOS.undent
      #!/bin/bash
      echo 'adr_bin_dir=\"#{bin}\"'
      echo 'adr_template_dir=\"#{prefix}\"'
    EOS

    prefix.install Dir["src/*.md"]
    bin.install Dir["src/*"]
  end

  test do
    assert_match(/0001-record-architecture-decisions.md/, shell_output("#{bin}/adr-init"))
    assert_match(/0001-record-architecture-decisions.md/, shell_output("#{bin}/adr-list"))
  end
end
