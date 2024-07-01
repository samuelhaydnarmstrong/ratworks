import { Construction } from "@mui/icons-material";
import { AppBar, Box, Paper, Toolbar, Typography } from "@mui/material";

export default function Home() {
  return (
    <Box>
      <AppBar position="static">
        <Toolbar>
          <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
            Ratworks
          </Typography>
        </Toolbar>
      </AppBar>
      <Box sx={{ width: "fit-content", margin: "20vh auto", display: "flex", alignItems: "center", flexDirection: "column" }}>
        <Construction sx={{ fontSize: "8em", color: "#646464" }} />
        <Typography sx={{ fontSize: "1.5em" }}>Under Construction</Typography>
      </Box>
    </Box>
  );
}
