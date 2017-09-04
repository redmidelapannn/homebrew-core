class Fits < Formula
  desc "File Information Tool Set"
  homepage "https://projects.iq.harvard.edu/fits"
  url "https://github.com/harvard-lts/fits/archive/1.2.0.tar.gz"
  sha256 "54a557cd1e559b4473dbbdd6bab561911ffaf090dfba258fab79604b50c3a46b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "881a484a39d36c4604035badf9a6ea8807bb7f7f07c0533a5d8e83a75ec47f71" => :sierra
    sha256 "342ec173729e051a5510edc14c19bd93e2e3afcdce2f21303d13333704ddf694" => :el_capitan
    sha256 "e91dc8048f4a1050b6920d5f59f99cfa62dd31dafee6d195dce94b4ea2f88120" => :yosemite
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
