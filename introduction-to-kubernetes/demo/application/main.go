package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"

	"demo/gin-server/config"

	"github.com/gin-gonic/gin"
)

type description struct {
	Color         string `json:"color"`
	HatchingPlace string `json:"hatch_place"`
}

type dragon struct {
	Race        string      `json:"race"`
	Name        string      `json:"name"`
	Age         int64       `json:"age"`
	Description description `json:"description" binding:"required"`
}

type probe struct {
	Health string `json:"health"`
	Type   string `json:"type"`
}

var dragons = []dragon{
	{Race: "ElderDragon", Name: "Tantaglia", Age: 100, Description: description{Color: "dark-blue", HatchingPlace: "Unkown"}},
	{Race: "SerpentDragon", Name: "Sintara", Age: 5, Description: description{Color: "dark-blue", HatchingPlace: "Rain Wilds"}},
	{Race: "SerpentDragon", Name: "Ranculos", Age: 5, Description: description{Color: "red", HatchingPlace: "Rain Wilds"}},
}

func getDragons(c *gin.Context) {
	c.IndentedJSON(http.StatusOK, dragons)
}

func postDragon(c *gin.Context) {
	var newDragon dragon

	if err := c.ShouldBindJSON(&newDragon); err != nil {
		fmt.Println(err)
		return
	}

	dragons = append(dragons, newDragon)

	resB, _ := json.Marshal(dragons)

	fmt.Println(string(resB))

	c.IndentedJSON(http.StatusCreated, dragons)
}

func getDragonByName(c *gin.Context) {
	name := c.Param("name")

	for _, i := range dragons {
		if i.Name == name {
			c.IndentedJSON(http.StatusOK, i)
			return
		}
	}

	c.IndentedJSON(http.StatusNotFound, gin.H{"message": "🐲 not found. Maybe it dead..."})
}

func readinessProbe(c *gin.Context) {
	readinessProbe, _ := json.Marshal(probe{Type: "readiness", Health: "ok"})
	c.IndentedJSON(http.StatusOK, string(readinessProbe))
}

func livenessProbe(c *gin.Context) {
	livenessProbe, _ := json.Marshal(probe{Type: "liveness", Health: "ok"})
	c.IndentedJSON(http.StatusOK, string(livenessProbe))
}

func main() {

	router := config.NewRouter()

	router.GET("/dragons", getDragons)
	router.POST("/dragon", postDragon)
	router.GET("/dragon/:name", getDragonByName)
	router.GET("/management/liveness", livenessProbe)
	router.GET("/management/readiness", readinessProbe)
	router.Run(fmt.Sprintf("%s:%s", os.Getenv("APP_HOSTNAME"), os.Getenv("APP_PORT")))
}
