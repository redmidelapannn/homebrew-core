class Namebench < Formula
  desc "DNS benchmark utility"
  homepage "https://code.google.com/archive/p/namebench/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/namebench/namebench-1.3.1-source.tgz"
  sha256 "30ccf9e870c1174c6bf02fca488f62bba280203a0b1e8e4d26f3756e1a5b9425"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f4e19ab0ba4a8f36957ad59b5440acacecc34acc5edd677720df3fb445f87126" => :mojave
    sha256 "e660802024e741dd0643d32641547a185fe08d69d3998128ab10510fdff22778" => :high_sierra
    sha256 "e660802024e741dd0643d32641547a185fe08d69d3998128ab10510fdff22778" => :sierra
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    system "python", "setup.py", "install", "--prefix=#{libexec}",
                     "--install-data=#{libexec}/lib/python2.7/site-packages"

    bin.install "namebench.py" => "namebench"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"namebench", "--query_count", "1", "--only", "8.8.8.8"
  end
end
