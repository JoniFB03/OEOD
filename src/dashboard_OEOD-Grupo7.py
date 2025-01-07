import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import yfinance as yf
# import talib as ta
from dash import Dash, html, dcc, callback, Output, Input, dash_table
import plotly.express as px
import plotly.graph_objects as go

ticker = "NVDA"
start_date = "2019-01-01"
end_date = "2024-11-01"
imagem_url = "https://th.bing.com/th/id/R.952ab16c7380e16b9f269e04481fabfc?rik=AXlfeVuBYRP54w&pid=ImgRaw&r=0"
cor_lettring = '#4EB82F'

###################################################################################################################
### imagem_url = "https://th.bing.com/th/id/R.952ab16c7380e16b9f269e04481fabfc?rik=AXlfeVuBYRP54w&pid=ImgRaw&r=0"
### cor_lettring = '#4EB82F'
### ticker = "NVDA"
###################################################################################################################


def get_data(ticker = "NVDA", start_date = "2019-01-01", end_date = "2024-11-01"):
    data = yf.download(ticker, start=start_date, end=end_date)
    return data

def data_prep(data):
    data = data.dropna()
    data.index = pd.to_datetime(data.index)
    data.index = data.index.strftime('%Y-%m-%d')
    data = data.reset_index()
    if isinstance(data.columns, pd.MultiIndex):
        data.columns = [' '.join(map(str, col)).strip() for col in data.columns]
    data.columns = [col.replace(f"{ticker}", "").replace("Ticker", "").strip() for col in data.columns]
    return data

data = get_data(ticker, start_date, end_date)
data = data_prep(data)
data['Date'] = pd.to_datetime(data['Date'])

app = Dash(__name__)

app.layout = html.Div(
    style={'backgroundColor': '#1e1e2f', 'color': '#f5f5f5', 'padding': '20px'},
    children=[
        # Título e imagem lado a lado
        html.Div([
            html.Img(
                src=f'{imagem_url}',
                style={'height': '50px', 'width': 'auto', 'marginRight': '20px'}
            ),
            html.H1(
                f"Dashboard da {ticker}",
                style={'textAlign': 'center', 'fontFamily': 'Arial', 'color': f'{cor_lettring}', 'display': 'inline-block'}
            )
        ], style={'display': 'flex', 'alignItems': 'center', 'justifyContent': 'center'}),
        
        html.Div(
            "Selecionar o tipo de gráfico:",
            style={'marginTop': 20, 'fontFamily': 'Arial', 'fontSize': '22px', 'color': f'{cor_lettring}'}
        ),
        dcc.RadioItems(
            options=[
                {'label': 'OHLC', 'value': 'OHLC'},
                {'label': 'Open', 'value': 'Open'},
                {'label': 'High', 'value': 'High'},
                {'label': 'Low', 'value': 'Low'},
                {'label': 'Close', 'value': 'Close'},
                {'label': 'Volume', 'value': 'Volume'}
            ],
            value='OHLC',  # default
            id='ohlc-variable',
            inline=True,
            style={
                'fontFamily': 'Arial', 'fontSize': '16px', 
                'backgroundColor': '#2a2a40', 'color': f'{cor_lettring}',
                'borderRadius': '5px', 'padding': '5px'
            },
            inputStyle={'backgroundColor': f'{cor_lettring}', 'borderRadius': '50%', 'width': '20px', 'height': '20px'},
            labelStyle={'fontSize': '16px', 'fontFamily': 'Arial'}
        ),
        dcc.Graph(id='ohlc-graph'),
        html.Hr(style={'borderColor': f'{cor_lettring}'}),
        html.H2("Tabela de Dados", style={'textAlign': 'center', 'fontFamily': 'Arial', 'color': f'{cor_lettring}'}),

        # Filtro de data
        html.Div("Selecionar o intervalo de datas da tabela:", style={'fontFamily': 'Arial', 'fontSize': '22px', 'color': f'{cor_lettring}'}),
        dcc.DatePickerRange(
            id='date-picker-range',
            start_date=data['Date'].min().strftime('%Y-%m-%d'),
            end_date=data['Date'].max().strftime('%Y-%m-%d'),
            display_format='YYYY-MM-DD',
            style={
                'fontFamily': 'Arial', 
                'fontSize': '24px',
                'backgroundColor': '#2a2a40', 
                'color': f'{cor_lettring}',
                'padding': '10px', 
                'marginTop': '20px',
                'borderRadius': '10px'
            }
        ),

        # Tabela com filtro
        dash_table.DataTable(
            id='data-table',
            data=data.to_dict('records'),
            page_size=10,
            style_table={'overflowX': 'auto'},
            style_header={
                'backgroundColor': '#2a2a40',
                'fontWeight': 'bold',
                'color': '#f5f5f5',
                'fontFamily': 'Arial'
            },
            style_data={
                'backgroundColor': '#1e1e2f',
                'color': '#f5f5f5',
                'fontFamily': 'Arial'
            },
            columns=[{
                'name': col,
                'id': col,
                'type': 'numeric',
                'format': {'specifier': '.3f'}
            } if col not in ['Date', 'Volume'] else {
                'name': col,
                'id': col,
                'type': 'datetime' if col == 'Date' else 'numeric',
                'format': {'specifier': '%Y-%m-%d'} if col == 'Date' else {'specifier': ',.0f'} 
            } for col in data.columns]
        )
    ]
)

# Callback para atualizar o gráfico
@callback(
    Output('ohlc-graph', 'figure'),
    Input('ohlc-variable', 'value')
)
def update_ohlc(selected_variable):
    if selected_variable == 'OHLC':
        fig = go.Figure(data=go.Ohlc(
            x=data['Date'],
            open=data['Open'],
            high=data['High'],
            low=data['Low'],
            close=data['Close'],
            increasing_line_color=f'{cor_lettring}',
            decreasing_line_color='#FF4C4C'
        ))
    elif selected_variable == 'Volume':
        fig = go.Figure(data=go.Bar(
            x=data['Date'],
            y=data['Volume'],
            name='Volume',
            marker_color=f'{cor_lettring}'
        ))
    else:
        fig = go.Figure(data=go.Scatter(
            x=data['Date'],
            y=data[f'{selected_variable}'],
            mode='lines',
            name=selected_variable,
            line=dict(color=f'{cor_lettring}')
        ))

    # Atualizar layout do gráfico para as vars diferentes
    fig.update_layout(
        title=f"Gráfico - {selected_variable}",
        xaxis_title="Data",
        yaxis_title="Preço (USD)" if selected_variable != 'Volume' else 'Volume',
        xaxis_rangeslider_visible=(selected_variable == 'OHLC'),
        plot_bgcolor='#1e1e2f',
        paper_bgcolor='#1e1e2f',
        font=dict(color='#f5f5f5'),
        height=1200,  # Altura do gráfico
        width=2200   # Largura do gráfico
    )
    return fig

@callback(
    Output('data-table', 'data'),
    Input('date-picker-range', 'start_date'),
    Input('date-picker-range', 'end_date')
)
def filter_data(start_date, end_date):
    # Filtrar os dados com base nas datas selecionadas
    filtered_data = data[(data['Date'] >= start_date) & (data['Date'] <= end_date)]
    return filtered_data.to_dict('records')

if __name__ == "__main__":
    app.run(debug=True)
