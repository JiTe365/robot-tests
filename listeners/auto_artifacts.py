from pathlib import Path
from robot.libraries.BuiltIn import BuiltIn

class AutoArtifacts:
    """On failure, try to screenshot with Browser if available & a page is open."""
    ROBOT_LISTENER_API_VERSION = 3

    def __init__(self, outdir="results/failures"):
        self.outdir = Path(outdir)
        self.outdir.mkdir(parents=True, exist_ok=True)

    def end_test(self, data, result):
        if result.passed:
            return

        bi = BuiltIn()
        # 1) Skip if Browser library not imported in this suite
        try:
            bi.get_library_instance("Browser")
        except Exception:
            return

        # 2) Skip if no page open (Get Page Ids available since rf-browser 12+)
        try:
            status, page_ids = bi.run_keyword_and_ignore_error("Get Page Ids")
            if status != "PASS" or not page_ids:
                return
        except Exception:
            return

        # 3) Try to capture a full page screenshot
        test_name = result.name.replace(" ", "_")
        path = self.outdir / f"{test_name}.png"
        try:
            bi.run_keyword("Take Screenshot", str(path), "fullPage=True")
        except Exception:
            # Don't fail the run because of the listener
            pass
