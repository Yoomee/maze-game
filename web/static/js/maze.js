import React from "react";

class Cell extends React.Component {
  render() {
    let player_names = this.props.players.map(player => (<div className="player">{player.name}</div>));
    return <div className={`${this.props.cellType} cell`}>{player_names}</div>
  }
}

class Row extends React.Component {
  render() {
    let row = this.props.cells.map(cell => <Cell {...cell}></Cell>);
    return (
          <div className="row" style={{flexDirection: "row", display: "flex"}}>
            {row}
          </div>
        );
  }
}

class Player extends React.Component {
  render() {
    let style = this.props.solved ? {backgroundColor: "lightgreen"} : {};
    return <div style={style}>{`${this.props.name} - ${this.props.location} - next move: ${this.props.direction} - ${this.props.move_count}`}</div>
  }
}

class NamePicker extends React.Component {
  constructor(props) {
    super(props);
    this.state = {name: ""};
  }
  handleSubmit(e){
    e.preventDefault();
    var name = this.state.name.trim();
    window.channel.push("set_name", {name: name})
    window.user = name;
    this.setState({name: ''});
  }
  handleNameChange(e){
    this.setState({name: e.target.value});
  }
  render() {
    return(
      <div>
        <form className="playerForm" className="form-inline" onSubmit={(e) => this.handleSubmit(e)}>
          <input type="text" className="form-control" placeholder="name" value={this.state.name} onChange={(e) => this.handleNameChange(e)} />
          <input type="submit" value="Post" className="btn" />
        </form>
      </div>
    )
  }
}

export default class Maze extends React.Component {
  constructor(props) {
    super(props);
  }

  tick() {
    window.channel.push("tick", {})
  }

  startTicker() {
    window.channel.push("start_ticker", {})
  }

  render() {
    console.log(this.props.maze);
    let maze = this.props.maze.map(row => {
      return <Row cells={row}></Row>
    });
    let players = this.props.players.map(player => <Player {...player[1]}></Player>);
    return (
        <div>
        <div onClick={this.tick}>{maze}</div>
        <h3>Players</h3>
        <div>{players}</div>
        <NamePicker />
        <button className="btn btn-primary" onClick={this.startTicker}>Start</button>
        </div>
        );
  }
}
