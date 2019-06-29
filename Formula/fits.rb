class Fits < Formula
  desc "File Information Tool Set"
  homepage "https://projects.iq.harvard.edu/fits"
  url "https://github.com/harvard-lts/fits/archive/1.2.1.tar.gz"
  sha256 "2cf9e39f7bf129d447ebe96a426d1d8dd1f1af9b1664b34e0918e9dc65c046bc"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bc6235ec22d549921c51f23df79bacfc43aea5c0edb824cba4ee2114b73c3eca" => :mojave
    sha256 "5c2b82ad3ddbdf3e7efb73003f55f99616e9ff162e1df9a68f8790a9216a8ba9" => :high_sierra
    sha256 "abfb591f7f69832f662f45d20dfcdcd653aad414b5dc51141552bfeee783b76b" => :sierra
  end

  depends_on "ant" => :build
  depends_on :java => "1.7+"
  uses_from_macos "zlib"

  def install
    system "ant", "clean-compile-jar", "-noinput"

    libexec.install "lib",
                    %w[tools xml],
                    Dir["*.properties"]

    (libexec/"lib").install "lib-fits/fits-#{version}.jar"

    inreplace "fits-env.sh" do |s|
      s.gsub! /^FITS_HOME=.*/, "FITS_HOME=#{libexec}"
      s.gsub! "${FITS_HOME}/lib", libexec/"lib"
    end

    inreplace %w[fits.sh fits-ngserver.sh],
              %r{\$\(dirname .*\)\/fits-env\.sh}, "#{libexec}/fits-env.sh"

    # fits-env.sh is a helper script that sets up environment
    # variables, so we want to tuck this away in libexec
    libexec.install "fits-env.sh"
    bin.install "fits.sh", "fits-ngserver.sh"
    bin.install_symlink bin/"fits.sh" => "fits"
    bin.install_symlink bin/"fits-ngserver.sh" => "fits-ngserver"
  end

  test do
    assert_match 'mimetype="audio/mpeg"',
      shell_output("#{bin}/fits -i #{test_fixtures "test.mp3"}")
  end
end
