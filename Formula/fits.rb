class Fits < Formula
  desc "File Information Tool Set"
  homepage "https://projects.iq.harvard.edu/fits"
  url "https://github.com/harvard-lts/fits/archive/1.2.0.tar.gz"
  sha256 "54a557cd1e559b4473dbbdd6bab561911ffaf090dfba258fab79604b50c3a46b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d730a8438d580ef0570ab1df1c956a54b82cfd94a12df0d5a533c492549115c3" => :high_sierra
    sha256 "dbb725932481ed6ffef3957c58365137cda287fae5a44940376fa1c6b64909ef" => :sierra
    sha256 "d22db501373f2d9ac3e7a6db863a8e7e6345e58e6d2c46cc34ff7ecacc3381fa" => :el_capitan
  end

  depends_on "ant" => :build
  depends_on :java => "1.7+"

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
