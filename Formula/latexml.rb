class Latexml < Formula
  desc "LaTeX to XML/HTML/MathML Converter"
  homepage "https://dlmf.nist.gov/LaTeXML/"
  url "https://dlmf.nist.gov/LaTeXML/releases/LaTeXML-0.8.2.tar.gz"
  sha256 "3d41a3012760d31d721b569d8c1b430cde1df2b68fcc3c66f41ec640965caabf"
  head "https://github.com/brucemiller/LaTeXML.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7381ad764480b5c4d657d1d0277fa2acffba820c358ca571cb3612d8de0489c7" => :high_sierra
    sha256 "4e08c4895880dabc22270ffa2ff2bff38cbaca4e1245b9c239a46ef87eb7e804" => :sierra
    sha256 "98bee607b20f8283423c9339a4ed4441bf578efea9f5c89d634123b7d11e177b" => :el_capitan
  end

  requires_perl = []
  requires_perl << "with-perl"
  depends_on "perl"                             # Actually, Imagemagick already installs Perl
  depends_on "imagemagick" => requires_perl     # Install ImageMagick with PerlMagick
  depends_on "ghostscript"
  depends_on "libxml2" if MacOS.version <= :sierra
  depends_on "libxslt" if MacOS.version <= :sierra

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    # Install the necessary Perl modules via a local CPAN
    system "curl -L https://cpanmin.us | PERL_CPANM_HOME=#{libexec}/localcpan perl - -q --notest --local-lib #{libexec} --save-dists #{libexec}/localcpan/CPAN --force App::cpanminus"
    system "PERL_CPANM_HOME=#{libexec}/localcpan perl #{libexec}/bin/cpanm -q --self-contained --notest --local-lib-contained #{libexec} --save-dists #{libexec}/localcpan/CPAN \
      Archive::Zip DB_File File::Which Getopt::Long Image::Size IO::String JSON::XS LWP MIME::Base64 Parse::RecDescent Pod::Parser SUPER Text::Unidecode \
      Test::More URI XML::LibXML XML::LibXSLT UUID::Tiny"
    # Remove all CPANM files
    remove_dir "#{libexec}/localcpan", :force => true
    remove ["#{libexec}/bin/config_data", "#{libexec}/bin/cpanm", "#{libexec}/bin/crc32", "#{libexec}/bin/imgsize", "#{libexec}/bin/json_xs",
            "#{libexec}/bin/lwp-download", "#{libexec}/bin/lwp-dump", "#{libexec}/bin/lwp-mirror", "#{libexec}/bin/lwp-request"], :force => true

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make", "install"
    doc.install "manual.pdf"
    (libexec+"bin").find.each do |path|
      next if path.directory?
      program = path.basename
      (bin+program).write_env_script("#{libexec}/bin/#{program}", :PERL5LIB => ENV["PERL5LIB"])
    end
  end

  def caveats
    <<~EOS
      LaTeXML can work without LaTeX; however, a LaTeX installation is highly recommended.
      You can install LaTeX here: https://www.tug.org/mactex/.
    EOS
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\title{LaTeXML Homebrew Test}
      \\begin{document}
      \\maketitle
      \\end{document}
    EOS
    assert_match %r{<title>LaTeXML Homebrew Test</title>},
    shell_output("#{bin}/latexml --quiet #{testpath}/test.tex")
  end
end
