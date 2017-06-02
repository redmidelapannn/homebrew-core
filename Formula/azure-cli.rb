class AzureCli < Formula
  include Language::Python::Virtualenv

  desc "Microsoft Azure CLI 2.0"
  homepage "https://docs.microsoft.com/en-us/cli/azure/overview"
  url "https://azurecliprod.blob.core.windows.net/releases/azure-cli_packaged_0.2.10.tar.gz"
  version "2.0.2.10"
  sha256 "be72ddb0983b3466e868602e68e4d3bf67379fbe080bdaa6aa321c03f9bcce48"
  head "https://github.com/Azure/azure-cli.git"

  bottle do
    sha256 "a3114837f47c367efc74052c75504b847cadfd0db4631725af1679f375458a6d" => :sierra
    sha256 "8b800f0204b102ecbacd46a93b4d3d4e44acdf606febeeb81e8431b62d081442" => :el_capitan
    sha256 "c1acdc10be4081f95ba7130bbc23fa90306f732d3f06e54a3f8b83ddf6502c51" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    virtualenv_create(libexec)
    bin_dir = libexec/"bin"

    components = [
      buildpath/"src/azure-cli",
      buildpath/"src/azure-cli-core",
      buildpath/"src/azure-cli-nspkg",
      buildpath/"src/azure-cli-command_modules-nspkg",
    ] + Pathname.glob("src/command_modules/azure-cli-*/")

    # Create wheel distribution of included components
    components.each do |c|
      c.cd { system bin_dir/"python", "setup.py", "bdist_wheel", "-d", buildpath/"dist" }
    end

    # Install CLI from wheel distributions
    system bin_dir/"pip", "install", "azure-cli", "-f", buildpath/"dist"

    # Generate executable
    (bin/"az").write <<-EOS.undent
      #!/usr/bin/env bash
      #{bin_dir}/python -m azure.cli "$@"
    EOS

    # Install bash completion
    bash_completion.install "az.completion" => "az"
  end

  test do
    version_output = shell_output("#{bin}/az --version")
    assert_match "azure-cli", version_output
  end
end
