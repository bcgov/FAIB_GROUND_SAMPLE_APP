#-------------------------------------------------------------------------------------------------
# Define UI
ui <- tagList(  
  css_hide_errors(),
  tags$link(rel = "stylesheet", type = "text/css", href = "bcgov2.css"),
                  waiter::use_waiter(),
                  waiter::waiter_show_on_load(html = waiter_html("Loading App")),
  shinyjs::useShinyjs(),
  gt::html("<header>
  <div class='banner'>
    <a href='https://gov.bc.ca' target=”_blank”>
      <img src='images/logo-banner.png' alt='Go to the Government of British Columbia website' />
    </a>
    <h2>Forest Inventory Sample Plots</h2>
  </div>
      <div class='other'>
      <a class='nav-btn'>
        <i class='fas fa-bars' id='menu' onclick='myFunction()'></i>
      </a>
    </div>
  </header>"),
  navbarPage(
    title = "",
             selected = "App",
             tabPanel(title = "App",
                      dashboardPage(
                        dashboardHeader(disable = TRUE),
                        
                        
                        #sidebar content
                        dashboardSidebar(disable = TRUE 
                        ),
                        
                        #body content
                        dashboardBody(
                          tags$head(tags$style(HTML('
                              .content-wrapper  {
                              font-weight: normal;
                              font-size: 14px;
                              }'))),
                          
                          fluidRow(  tags$head(
                            tags$style(HTML('#samplePlotsHelpGen{color:black}'))
                          ),
                          tags$head(
                            tags$style(HTML('#samplePlotsHelpAct{color:black}'))
                          ),
                          tags$head(
                            tags$style(HTML('#projDesHelp{color:black}'))
                          ),
                          column(width = 9, box(width=NULL,leafletOutput("map", height = 550)),
                                 box(width=NULL, height = 260,
                                     title=h3("Ground Sample Description at Last Measurement", 
                                              style = 'font-size:14px;color:black;font-weight:bold;'),
                                     tabBox(width = NULL,
                                            # The id lets us use input$tabset1 on the server to find the current tab
                                            id = "tabset1"#, height = "0"
                                            , tabPanel("Volume/Age",  plotlyOutput('age', height = "250px"))
                                            , tabPanel("Species",  plotlyOutput('species', height = "250px"))
                                            #, tabPanel("BA by Year",  plotlyOutput('BAbyyear', height = "250px"))
                                            , tabPanel("BEC Zone",  plotlyOutput('BEC', height = "250px"))
                                            , tabPanel("Last Measurement",  plotlyOutput('Samples', height = "250px"))
                                            # ####FOR DEBUG####
                                            , tabPanel("Measurement Count",  plotlyOutput('MeasCount', height = "250px"))
                                            ,
                                            # tabPanel("Volume/Age",dataTableOutput("table1")),
                                            # tabPanel("Volume/Age",dataTableOutput("table3")),
                                            #tabPanel("Memory",textOutput("Memory"))
                                            
                                     )
                                     
                                 )
                          ),
                          
                          column(
                            tags$head(tags$style(HTML("#tsa ~ .selectize-control 
                                          .selectize-input {
                                         max-height: 90px;
                                         overflow-y: auto;}
                                         .selectize-dropdown-content {
                                          max-height: 90px;
                                          overflow-y: auto;}
                                         "))),
                            tags$head(tags$style(HTML("#bec ~ .selectize-control 
                                          .selectize-input {
                                         max-height: 90px;
                                         overflow-y: auto;}
                                         .selectize-dropdown-content {
                                          max-height: 90px;
                                          overflow-y: auto;}
                                         "))),
                            width = 3,height = 400,
                            box(width=NULL,
                                    title = "Filter Data ",  
                                    closable = FALSE, 
                                    status = "primary", 
                                    solidHeader = TRUE, 
                                    collapsible = FALSE,
                                    collapsed = FALSE,
                                    actionButton("fb", "Filter", width = "100%"),
                                    radioButtons("shapeFilt",
                                                 "Select Shape Filter",
                                                 choices = c("None","Drawn Polygon", "Shapefile", "Both"),
                                                 selected = "None",
                                                 inline = FALSE),
                                checkboxGroupInput("cbSType",
                                                   actionLink("samplePlotsHelpGen", "Generalized Coordinates ",icon =icon("info-circle",verify_fa = FALSE)),
                                                   choices = c("CMI","YSM", "NFI", "SUP"),
                                                   selected = c("CMI","YSM", "NFI", "SUP"),
                                                   inline = TRUE),
                                    checkboxGroupInput("sts",
                                                       actionLink("samplePlotsHelpAct", "Actual Coordinates ",icon =icon("info-circle",verify_fa = FALSE)),
                                                       choiceNames = c("VRI","PSP Active","PSP Inactive"),
                                                       choiceValues = c("VRI","PA","PI"),
                                                       selected = c("VRI","PA","PI"),
                                                       inline = TRUE),
                                    
                                    selectizeInput(
                                      "tsa",
                                      "Select TSA",
                                      choices = c("Clear All","Select All", tsaBnds),
                                      selected = tsaBnds,
                                      multiple = TRUE, 
                                      options = list('plugins' = list('remove_button'), placeholder = 'Select a Timber Supply Area', 'persist' = TRUE)),
                                    selectizeInput("bec",
                                                   "Select Bec Zone",
                                                   choices = c("Clear All","Select All",becLst),
                                                   selected = becLst,
                                                   multiple = TRUE,
                                                   options = list('plugins' = list('remove_button'), placeholder = 'Select a BEC Zone', 'persist' = TRUE)),
                                    
                                    # checkboxGroupInput("prj2",
                                    #                    "Select Project Design",
                                    #                    choices = c("NONE","GRID","RANDOM"),
                                    #                    selected = c("NONE","GRID","RANDOM"),
                                    #                    inline = TRUE),
                                    radioButtons("prj",
                                                 actionLink("projDesHelp", "Select Project Design ",icon =icon("info-circle",verify_fa = FALSE)),
                                                 choices = c("All","YSM Main","Mat Main"),
                                                 selected = "All",
                                                 inline = TRUE)
                            ),
                            
                            box( 
                              closable = FALSE, 
                              status = "primary", 
                              solidHeader = TRUE, 
                              collapsible = FALSE,
                              collapsed = FALSE,
                              width = NULL,
                              actionButton("db", "Export Data as CSV", width="100%")
                            )
                            
                          )
                          )
                        )
                      )                      
                      
                      
                      ),
             tabPanel(title = "User Guide", wellPanel(
                      includeMarkdown("www//guide.md")
               )),
             tabPanel(title = "About", wellPanel(
                      includeMarkdown("www//about.md")
               ))),

tags$head(tags$script(HTML('
                           Shiny.addCustomMessageHandler("jsCode",
                           function(message) {
                           eval(message.value);
                           });'
))),

downloadLink("downloadCSV",label=""),

div(class = "footer",
    includeHTML("www/footer.html")
)
)
